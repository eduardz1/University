CC := nvcc

BIN := bin
OBJ := obj
$(info $(shell mkdir -p $(BIN) $(OBJ)))

.PHONY: all

all: simple
	
simple: $(BIN)/simple
$(BIN)/simple: $(OBJ)/simple.o
	$(CC) -o $@ $^	

$(OBJ)/%.o : %.cu
	$(CC) -c $< -o $@

run: all
	srun --gres=shard:1 --cpus-per-task=4 --mem=2GB $(BIN)./simple
