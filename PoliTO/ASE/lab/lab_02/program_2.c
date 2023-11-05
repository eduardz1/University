#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  double i[30] = {1.0,  2.0,  3.0,  4.0,  5.0,  6.0,  7.0,  8.0,  9.0,  10.0,
                  11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0,
                  21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0};
  double w[30] = {0.1,   0.2,   0.3,   0.4,   0.5,   0.6,   0.7,   0.8,
                  0.9,   0.11,  0.01,  0.01,  0.03,  0.04,  0.05,  0.06,
                  0.07,  0.08,  0.09,  0.12,  0.001, 0.002, 0.003, 0.004,
                  0.005, 0.006, 0.007, 0.008, 0.009, 0.13};

  double b = 0xab;
  double y = 0;

  const int64_t nan = 0x7ff;
  int64_t exponent = 0;
  double res = 0;

  for (int k = 0; k < 30; k++) {
    res = (i[k] * w[k] + b);

    exponent = ((int64_t)res) << 1;
    exponent >>= 53;

    if (exponent != nan)
      y += res;
  }

  printf("%f\n", y);
}