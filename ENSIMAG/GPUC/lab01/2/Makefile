GC := nvcc
CC := g++

BIN := bin
OBJ := obj
$(info $(shell mkdir -p $(BIN) $(OBJ)))

.PHONY: all

all: matrix_cpu matrix_gpu

matrix_cpu: $(BIN)/matrix_cpu
$(BIN)/matrix_cpu: $(OBJ)/matrix_cpu.o
	$(CC) -o $@ $^

$(OBJ)/matrix_cpu.o : matrix_cpu.cpp
	$(CC) -c $< -o $@

matrix_gpu: $(BIN)/matrix_gpu
$(BIN)/matrix_gpu: $(OBJ)/matrix_gpu.o
	$(GC) -o $@ $^

$(OBJ)/matrix_gpu.o : matrix_gpu.cu
	$(GC) -c $< -o $@

gpu: matrix_gpu
	srun --gres=shard:1 --cpus-per-task=4 --mem=2GB $(BIN)./matrix_gpu

cpu: matrix_cpu
	./matrix_cpu