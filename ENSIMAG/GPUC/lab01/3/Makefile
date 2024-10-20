GC := nvcc
CC := g++

BIN := bin
OBJ := obj
$(info $(shell mkdir -p $(BIN) $(OBJ)))

.PHONY: all

all: mandelbrot_cpu mandelbrot_gpu

mandelbrot_cpu: $(BIN)/mandelbrot_cpu
$(BIN)/mandelbrot_cpu: $(OBJ)/mandelbrot_cpu.o $(OBJ)/readppm.o
	$(CC) -o $@ $^

$(OBJ)/mandelbrot_cpu.o : mandelbrot.cpp
	$(CC) -c $< -o $@

readppm: $(OBJ)/readppm.o
$(OBJ)/readppm.o : readppm.cpp
	$(CC) -c $< -o $@

mandelbrot_gpu: $(BIN)/mandelbrot_gpu
$(BIN)/mandelbrot_gpu: $(OBJ)/mandelbrot_gpu.o $(OBJ)/readppm.o
	$(GC) -o $@ $^

$(OBJ)/mandelbrot_gpu.o : mandelbrot.cu
	$(GC) -c $< -o $@

gpu: mandelbrot_gpu
	srun --gres=shard:1 --cpus-per-task=4 --mem=2GB $(BIN)/mandelbrot_gpu

cpu: mandelbrot_cpu
	./$(BIN)/mandelbrot_cpu