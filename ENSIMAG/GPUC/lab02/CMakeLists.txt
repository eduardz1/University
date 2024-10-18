cmake_minimum_required(VERSION 3.12)

# set the project name and version
project(MatrixMultiply LANGUAGES CXX)

# set CXX standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories(${PROJECT_SOURCE_DIR})

# Linear algebra package
find_package(BLAS)
if(BLAS_FOUND)
  include_directories(${BLAS_LIBRARIES})
endif()

# Shared memory parallelism
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
  add_executable(gemm_cpu main_cpu.cxx)
	target_link_libraries(gemm_cpu PUBLIC OpenMP::OpenMP_CXX)
endif()

# CUDA Libraries
find_package(CUDA)
if(CUDA_FOUND)
  enable_language(CUDA)
  include_directories(${CUDA_INCLUDE_DIRS} )
  add_executable(gemm_cuda main_gpu.cu)
endif()