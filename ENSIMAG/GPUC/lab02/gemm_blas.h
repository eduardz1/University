// -----------------------------------------------------------------------------
// * Name:       gemm_blas.h
// * Purpose:    Provide a set of kernel for matrix multiplication
// * History:    Christophe Picard, Fall 2021
// -----------------------------------------------------------------------------

#pragma once

/// Basic Linear Algebra Libraries
#ifdef __APPLE__
#include <Accelerate/Accelerate.h>
#else
#include <cblas>
#endif

/// Parallelism on CPU
#include <omp.h>

/// ----------------------------------------------------------------------------
/// \fn void gemm_cpu_blas_seq(T *&A, T *&B, T *&C, int M, int N, int K) 
/// \brief Compute sequential matrix product using three BLAS 
/// \param A First matrix in the product
/// \param B Second matrix in the product
/// \param C Output matrix
/// \param M Number of rows of A
/// \param N Number of columns of B
/// \param K Number of rows of B
/// ----------------------------------------------------------------------------
template <typename T>
void gemm_cpu_blas_seq(T *&A, T *&B, T  *&C, int M, int N, int K) {
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, &A[0], K,
              &B[0], N, 0.0, &C[0], N);
}
