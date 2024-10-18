// -----------------------------------------------------------------------------
// * Name:       main_gpu.cxx
// * Purpose:    Driver for matrix multiplication on GPU
// * History:    Christophe Picard, Fall 2021
// -----------------------------------------------------------------------------

// includes, system
#include <cmath>
#include <iostream>
#include <string>

#include <cuda.h>

// Parsing command line options using cxxopts 
// https://github.com/jarro2783/cxxopts.git
#include "args.hxx"

// Matrix manipulation function
#include "matrix_utils.h"

// Define different gemm kernel
#include <gemm_kernel.cuh>


#define REAL float
#define BLOCK_SIZE 32

///
/// Top level driver
///
int main(int argc, char **argv) {

  std::cout << "[Matrix Multiply Using CUDA] - Starting..." << std::endl;

  // Define parser 
  args::ArgumentParser parser("gemm_cuda", "Matrix Multiply using CUDA");

  // Set parser value
  args::HelpFlag help(parser, "help", "Display this help menu", {'h', "help"});
  args::ValueFlag<int> widthA(parser, "widthA", "Width of matrix A", {"wA"}, 256);
  args::ValueFlag<int> widthB(parser, "widthB", "Width of matrix B", {"wB"}, 256);
  args::ValueFlag<int> heightA(parser, "heightA", "Height of matrix A", {"hA"},256);
  args::ValueFlag<int> heightB(parser, "heightB", "Height of matrix B", {"hB"}, 256);
  
  // Invoke parser
  try {
    parser.ParseCLI(argc, argv);
  } catch (args::Help) {
    std::cout << parser;
    return 0;
  } catch (args::ParseError e) {
    std::cerr << e.what() << std::endl;
    std::cerr << parser;
    return 1;
  } catch (args::ValidationError e) {
    std::cerr << e.what() << std::endl;
    std::cerr << parser;
    return 1;
  }

  // Initialize matrix dimensions
  int WA = args::get(widthA);
  int WB = args::get(widthB);
  int HA = args::get(heightA);
  int HB = args::get(heightB);
  int WC = WA;
  int HC = HB;

  // Setup CUDA environnement 
  cudaError_t error;

  cudaDeviceProp deviceProp;
  int devID = 0;
  error = cudaGetDevice(&devID);

  if (error != cudaSuccess) {
    printf("cudaGetDevice returned error code %d, line(%d)\n", error, __LINE__);
  }

  error = cudaGetDeviceProperties(&deviceProp, devID);

  if (deviceProp.computeMode == cudaComputeModeProhibited) {
    std::cerr << "Error: device is running in <Compute Mode Prohibited>, no threads can use ::cudaSetDevice() ." <<std::endl;
    exit(EXIT_SUCCESS);
  }

  if (error != cudaSuccess) {
    printf("cudaGetDeviceProperties returned error code %d, line(%d)\n", error, __LINE__);
  } else {
    printf("GPU Device %d: \"%s\" with compute capability %d.%d\n\n", devID, deviceProp.name, deviceProp.major, deviceProp.minor);
  }

  // utilities
  cudaEvent_t start;
  cudaEvent_t stop;
  float msecTotal;

  // allocate host memory for matrices A and B
  unsigned int size_A = WA * HA;
  unsigned int mem_size_A = sizeof(float) * size_A;
  float *h_A = (float *)malloc(mem_size_A);
  unsigned int size_B = WB * HB;
  unsigned int mem_size_B = sizeof(float) * size_B;
  float *h_B = (float *)malloc(mem_size_B);
  
  // initialize host memory
  fill_random<REAL>(h_A, WA, HA);
  fill_random<REAL>(h_B, WB, HB);
 
  // allocate device memory
  float *d_A;
  cudaMalloc((void **)&d_A, mem_size_A);
  float *d_B;
  cudaMalloc((void **)&d_B, mem_size_B);

  // allocate device memory for result
  unsigned int size_C = WA * HB;
  unsigned int mem_size_C = sizeof(float) * size_C;
  float *d_C;
  cudaMalloc((void **)&d_C, mem_size_C);

  // allocate host memory for the result
  float *h_C = (float *)malloc(mem_size_C);

  dim3 threads, grid;

  // create and start timer
  cudaEventCreate(&start);
  cudaEventRecord(start, NULL);
 
  // copy host memory to device
  cudaMemcpy(d_A, h_A, mem_size_A, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, mem_size_B, cudaMemcpyHostToDevice);

  // setup execution parameters
  threads = dim3(BLOCK_SIZE, BLOCK_SIZE);
  grid = dim3(WC / threads.x, HC / threads.y);
  
  // execute the kernel
  gemm_naive<<<grid, threads>>>(d_C, d_A, d_B, WA, WB);

  // copy result from device to host
  cudaMemcpy(h_C, d_C, mem_size_C, cudaMemcpyDeviceToHost);

  // stop and destroy timer
  cudaEventCreate(&stop);
  cudaEventRecord(stop, NULL);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&msecTotal, start, stop);

  /* Performance computation, results and performance printing ------------ */
  auto flop = 2 * (float)WC * (float)HC * (float)WA;

  std::cout << " == Performances " << std::endl;
  std::cout << "\t Processing time: " << msecTotal << " (ms)"
            << std::endl;
  std::cout << "\t GFLOPS: " << flop / msecTotal / 1e+6 << std::endl;

  return (EXIT_SUCCESS);
}
