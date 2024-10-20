#include "readppm.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <string>

unsigned char *pixels = NULL;
int gImageWidth, gImageHeight;

// Init image data
void initBitmap(int width, int height) {
  if (pixels)
    free(pixels);
  pixels = (unsigned char *)malloc(width * height * 4);
  gImageWidth = width;
  gImageHeight = height;
}

#define DIM 512

// Select precision here! float or double!
#define MYFLOAT float

// User controlled parameters
int maxiter = 20;
MYFLOAT offsetx = -200, offsety = 0, zoom = 0;
MYFLOAT scale = 1.5;

// Complex number class
struct cuComplex {
  MYFLOAT r;
  MYFLOAT i;

  cuComplex(MYFLOAT a, MYFLOAT b) : r(a), i(b) {}

  float magnitude2(void) { return r * r + i * i; }

  cuComplex operator*(const cuComplex &a) {
    return cuComplex(r * a.r - i * a.i, i * a.r + r * a.i);
  }

  cuComplex operator+(const cuComplex &a) {
    return cuComplex(r + a.r, i + a.i);
  }
};

int mandelbrot(int x, int y) {
  MYFLOAT jx = scale * (MYFLOAT)(gImageWidth / 2 - x + offsetx / scale) /
               (gImageWidth / 2);
  MYFLOAT jy = scale * (MYFLOAT)(gImageHeight / 2 - y + offsety / scale) /
               (gImageWidth / 2);

  cuComplex c(jx, jy);
  cuComplex a(jx, jy);

  int i = 0;
  for (i = 0; i < maxiter; i++) {
    a = a * a + c;
    if (a.magnitude2() > 1000)
      return i;
  }

  return i;
}

void computeFractal(unsigned char *ptr) {
  // map from x, y to pixel position
  for (int x = 0; x < gImageWidth; x++)
    for (int y = 0; y < gImageHeight; y++) {
      int offset = x + y * gImageWidth;

      // now calculate the value at that position
      int fractalValue = mandelbrot(x, y);

      // Colorize it
      int red = 255 * fractalValue / maxiter;
      if (red > 255)
        red = 255 - red;
      int green = 255 * fractalValue * 4 / maxiter;
      if (green > 255)
        green = 255 - green;
      int blue = 255 * fractalValue * 20 / maxiter;
      if (blue > 255)
        blue = 255 - blue;

      ptr[offset * 4 + 0] = red;
      ptr[offset * 4 + 1] = green;
      ptr[offset * 4 + 2] = blue;

      ptr[offset * 4 + 3] = 255;
    }
}

// Main program, inits
int main(int argc, char **argv) {
  initBitmap(DIM, DIM);
  computeFractal(pixels);

  // Dump to PPM
  writeppm("fractalout.ppm", DIM, DIM, pixels);
}