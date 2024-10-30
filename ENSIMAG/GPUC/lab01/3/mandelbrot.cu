#include "readppm.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cuComplex.h>
#include <iostream>
#include <string>

#define DIM 512
#define MAXITER 20

#define offsetx -200
#define offsety 0
#define zoom 0
#define scale 1.5

__global__ void mandelbrot(int *fractalValue, int x, int y) {
  float jx = scale * (float)(DIM / 2 - x + offsetx / scale) / (DIM / 2);
  float jy = scale * (float)(DIM / 2 - y + offsety / scale) / (DIM / 2);

  cuFloatComplex c = make_cuFloatComplex(jx, jy);
  cuFloatComplex a = make_cuFloatComplex(jx, jy);

  int i = 0;
  for (i = 0; i < MAXITER; i++) {
    a = cuCmulf(a, a);        // Multiply a by itself
    a = cuCaddf(a, c);        // Add c to the result
    if (cuCabsf(a) > 1000.0f) // Use cuCabsf to get the magnitude
      break;
  }

  *fractalValue = i;
}

void computeFractal(unsigned char *ptr) {
  // map from x, y to pixel position
  for (int x = 0; x < DIM; x++)
    for (int y = 0; y < DIM; y++) {
      int offset = x + y * DIM;

      // now calculate the value at that position
      int fractalValue;
      mandelbrot<<<1, 1>>>(&fractalValue, x, y);

      std::clog << "Fractal value: " << fractalValue << std::endl;

      cudaDeviceSynchronize();

      // Colorize it
      int red = 255 * fractalValue / MAXITER;
      if (red > 255)
        red = 255 - red;
      int green = 255 * fractalValue * 4 / MAXITER;
      if (green > 255)
        green = 255 - green;
      int blue = 255 * fractalValue * 20 / MAXITER;
      if (blue > 255)
        blue = 255 - blue;

      ptr[offset * 4 + 0] = red;
      ptr[offset * 4 + 1] = green;
      ptr[offset * 4 + 2] = blue;

      ptr[offset * 4 + 3] = 255;

      cudaFree(&fractalValue);
    }
}

// Main program, inits
int main(int argc, char **argv) {
  unsigned char *pixels;

  pixels = (unsigned char *)malloc(DIM * DIM * 4);

  computeFractal(pixels);

  // Dump to PPM
  writeppm("fractalout_gpu.ppm", DIM, DIM, pixels);
}