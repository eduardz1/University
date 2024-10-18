
// -----------------------------------------------------------------------------
// * Name:       main_cpu.cxx
// * Purpose:    Driver for matrix multiplication on CPU
// * History:    Christophe Picard, Fall 2021
// -----------------------------------------------------------------------------

#include <chrono>
#include <cmath>
#include <iostream>

// #include <typeinfo>

// Parsing command line options using cxxopts 
// https://github.com/jarro2783/cxxopts.git
#include "args.hxx"

#include "gemm_noblas.h"
#include "matrix_utils.h"

/*----------------------------------------------------------------------------*/
/* Floating point datatype and op                                             */
/*----------------------------------------------------------------------------*/
#ifdef DP
typedef double REAL;
#else
typedef float REAL;
#endif
#define check_out 1

/*----------------------------------------------------------------------------*/
/* Toplevel function.                                                         */
/*----------------------------------------------------------------------------*/
int main(int argc, char *argv[]) {
  std::cout << "[Matrix Multiply Using CPU]" << std::endl;

  // Define parser 
  args::ArgumentParser parser("gemm_cpu", "Matrix Multiply using CPU");

  // Set parser value
  args::HelpFlag help(parser, "help", "Display this help menu", {'h', "help"});
  args::ValueFlag<int> widthA(parser, "widthA", "Width of matrix A", {"wA"},
                              256);
  args::ValueFlag<int> heightA(parser, "heightA", "Height of matrix A", {"hA"},
                               256);
  args::ValueFlag<int> widthB(parser, "widthB", "Width of matrix B", {"wB"},
                              256);
  args::ValueFlag<int> heightB(parser, "heightB", "Height of matrix B", {"hB"},
                               256);

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
  int WA, WB, HA, HB, WC, HC;
  WA = args::get(widthA);
  WB = args::get(widthB);
  HA = args::get(heightA);
  HB = args::get(heightB);

  // Initialisation 
  int M = WA;
  int N = HA;
  int K = WB;

  REAL *A = new REAL[M*K];
  REAL *B = new REAL[K*N];

  fill_random<REAL>(A, M, K);
  fill_random<REAL>(B, K, N);
  REAL *C = new REAL[M*N];
  REAL *TB = new REAL[N*K];
  fill_zero<REAL>(C, M, N);


  // Matrix product computation
  std::cout << " Product of two matrices of float"
            << " of size " << M << "x" << K << " and " << K << "x" << N
            << std::endl;

  std::cout << " == Computation starts..." << std::endl;

  auto start = std::chrono::system_clock::now();

  gemm_cpu_noblas_par<REAL>(A, B, C, M, N, K); 
  
  auto elapse = std::chrono::system_clock::now() - start;
  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(elapse);

  /* Performance computation, results and performance printing ------------ */
  auto flop = 2 * M * N * K ;

  std::cout << " == Performances " << std::endl;
  std::cout << "\t Processing time: " << duration.count() << " (ms)"
            << std::endl;
  std::cout << "\t GFLOPS: " << flop / duration.count() / 1e+6 << std::endl;

  if (check_out)
    check_result<REAL>(A, B, C, M, N, K); // Res checking

  /* End of the parallel program ------------------------------------------ */
  return (EXIT_SUCCESS);
}