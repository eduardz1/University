// -----------------------------------------------------------------------------
// * Name:       matrix_utils.h
// * Purpose:    Provide a set of function to manipulate matrices 
// * History:    Christophe Picard, Fall 2021
// -----------------------------------------------------------------------------

#pragma once

/// I/O Libraries
#include <iostream>
#include <fstream>
#include <string>

/// Number manipulation
#include <limits>
#include <cmath>

/// Random number generation
#include <random>
#include <ctime>

/// Only for checking
#include "gemm_noblas.h"

/// ----------------------------------------------------------------------------
/// \fn void init_mat( int N, T *&A, T *&B)
/// \brief Set matrix coefficients
/// \param A First matrix to initialize 
/// \param B Second matrix to initialize 
/// \param N Size of the matrix
/// ----------------------------------------------------------------------------
template <typename T> void fill_random(T *&A, int N, int M) {
  std::mt19937 e(static_cast<unsigned int>(std::time(nullptr)));
  std::uniform_real_distribution<T> f;
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < M; ++j) {
      A[i * M + j] = f(e);
    }
  }
}

/// ----------------------------------------------------------------------------
/// \fn void fill_zero( T *&A, int M, int N )
/// \brief Set matrix coefficients to zero
/// \param A Matrix to initialize 
/// \param M Number of rows of the matrix
/// \param N Number of columns of the matrix
/// ----------------------------------------------------------------------------
template <typename T> void fill_zero(T *&A, int M, int N) {
  for (int i = 0; i < M; ++i) {
    for (int j = 0; j < N; ++j) {
      A[i * M + j] = T(0.0);
    }
  }
}

/// ----------------------------------------------------------------------------
/// \fn bool load_matrix(char * filename, T * &A, int &nx, int &ny) 
/// \brief Read matrix from a file
/// \param filename name of the file containing the matrix
/// \param matrix store the loaded coefficient
/// \param M number of rows of the matrix
/// \param N nimber of columns of the matrix
/// ----------------------------------------------------------------------------
template <typename T> bool load_matrix(char *filename, T *&A, int &M, int &N) {
  std::string line;
  std::ifstream infile(filename);

  if (!infile.is_open()) {
    std::cerr << "File not found: " << filename << std::endl;
    std::exit(EXIT_FAILURE);
  }

  // Load the size of the matrix
  infile >> M >> N;

  // Allocate memory for the matrix
  A = new T[M * N];

  // Load matrix coefficients
  for (int i = 0; i < M * N; i++) {
    infile >> A[i];
  }

  infile.close();
  return 1;
}

/// ----------------------------------------------------------------------------
/// \fn void check_result( int N, T *&A, T *&B, T *&C)
/// \brief Check the correcteness of the computation
/// \param N Size of the matrix
/// \param A First matrix in the product
/// \param B Second matrix in the product
/// \param C Output matrix
/// ----------------------------------------------------------------------------
template<typename T>
void check_result(T *&A, T *&B, T *&C, int M, int N, int K) {
  T *C_check = new T[M*N];
  std::cout<< " == Checking results against sequential CPU" <<std::endl;
  gemm_cpu_noblas_seq<T>(A, B, C_check, M, N, K);

  // Comparing the different results
  // - maximum difference
  double max_diff = 0.0;
  // - position with the largest relative difference
  int max_X = 0;
  int max_Y = 0;
  // - epsilon for relative differences
  auto epsilon = std::pow(10.,2-(std::numeric_limits<T>::digits10));

  // - number of cases where the error is too large
  int cases = 0;

  for (int i = 0; i < M; ++i) {
    for (int j = 0; j < N; ++j) {
      // difference between results
      auto diff = fabs(C[i * M + j] - C_check[i * M + j]);
      auto standard = fabs(C_check[i * M + j]);

      // Checks if the difference is large with respect to number representation.
      if (diff > standard * epsilon) {
        ++cases; // Register the case
      }
      // Store the largest difference seen so far
      if (diff > standard * max_diff) {
        max_diff = diff / standard;
        max_X = i;
        max_Y = j;
      }
    }
  }

  if (cases == 0) {
    std::cout << "\t The results are correct for " << typeid(A).name()
              << " with a precision of " << epsilon << std::endl;
    std::cout << "\t Maximum relative difference encountered: " << max_diff
              << std::endl;
  } else {
    std::cout << "*** WARNING ***" << std::endl;
    std::cout << "\t The results are incorrect for float" << " "
              << " with a precision of " << epsilon << std::endl;
    std::cout << "\t Number of cell with imprecise results: " << cases
              << std::endl;
    std::cout << "\t Cell C[" << max_X << "][" << max_Y
              << "] contained the largest relative difference of " << max_diff
              << std::endl;
    std::cout<< "\t Expected value:<" <<C_check[max_X*N + max_Y]<<std::endl;
    std::cout<< "\t Computed value: " <<C[max_X*N + max_Y]<<std::endl;
  }
}

/// ----------------------------------------------------------------------------
/// \fn void trans( int N, T *&A, T *&B)
/// \brief Perform transposition of a matrix
/// \param N Size of the matrix
/// \param A Matrix to transpose 
/// \param B Transposed matrix 
/// ----------------------------------------------------------------------------
template<typename T>
void transpose(T *&B, T *&Btrans, int M, int N) {
  for (int i = 0; i < M; i++)
    for (int j = 0; j < N; j++)
      Btrans[j * N + i] = B[i * M + j];
}

