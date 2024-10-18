// Matrix addition, CPU version

#include <iostream>
void add_matrix(float *a, float *b, float *c, int N) {
  int index;

  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      index = i + j * N;
      c[index] = a[index] + b[index];
    }
}

int main() {
  const int N = 16;

  float a[N * N];
  float b[N * N];
  float c[N * N];

  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      a[i + j * N] = 10 + i;
      b[i + j * N] = float(j) / N;
    }

  add_matrix(a, b, c, N);

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      std::cout << c[i + j * N] << " ";
    }
    std::cout << std::endl;
  }
}