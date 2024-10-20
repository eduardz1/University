#include <iostream>

__global__ void add_matrix(float *a, float *b, float *c, const int n) {
  int i = threadIdx.x + blockIdx.x * blockDim.x;
  int j = threadIdx.y + blockIdx.y * blockDim.y;

  if (i < n && j < n) {
    c[i * n + j] = a[i * n + j] + b[i * n + j];
  }
}

int main() {
  const int N = 16;

  float *a, *b, *c;

  cudaEvent_t start, stop;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaMallocManaged(&a, N * N * sizeof(float));
  cudaMallocManaged(&b, N * N * sizeof(float));
  cudaMallocManaged(&c, N * N * sizeof(float));

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      a[i + j * N] = 10 + i;
      b[i + j * N] = float(j) / N;
    }
  }

  dim3 dimBlock(16, 16);
  dim3 dimGrid((N + dimBlock.x - 1) / dimBlock.x,
               (N + dimBlock.y - 1) / dimBlock.y);

  cudaEventRecord(start);
  add_matrix<<<dimGrid, dimBlock>>>(a, b, c, N);
  cudaEventRecord(stop);

  cudaDeviceSynchronize();

  cudaEventSynchronize(start);
  cudaEventSynchronize(stop);

  float time;
  cudaEventElapsedTime(&time, start, stop);

  std::cout << "Time: " << time << " ms" << std::endl;

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      std::cout << c[i + j * N] << " ";
    }
    std::cout << std::endl;
  }

  cudaFree(a);
  cudaFree(b);
  cudaFree(c);

  return EXIT_SUCCESS;
}