CC := clang
CFLAGS := 

BIN := bin
OBJ := obj
$(info $(shell mkdir -p $(BIN) $(OBJ)))

.PHONY: all

all: bTree concat-Hash kTree List open-Hash parent-bTRee Queue

bTree: $(BIN)/bTree
$(BIN)/bTree: $(OBJ)/bTree.o
	$(CC) $(CFLAGS) -o $@ $^

concat-Hash: $(BIN)/concat-Hash
$(BIN)/concat-Hash: $(OBJ)/concat-Hash.o
	$(CC) $(CFLAGS) -o $@ $^

kTree: $(BIN)/kTree
$(BIN)/kTree: $(OBJ)/kTree.o
	$(CC) $(CFLAGS) -o $@ $^

List: $(BIN)/List
$(BIN)/List: $(OBJ)/List.o
	$(CC) $(CFLAGS) -o $@ $^

open-Hash: $(BIN)/open-Hash
$(BIN)/open-Hash: $(OBJ)/open-Hash.o
	$(CC) $(CFLAGS) -o $@ $^

parent-bTRee: $(BIN)/parent-bTRee
$(BIN)/parent-bTRee: $(OBJ)/parent-bTRee.o
	$(CC) $(CFLAGS) -o $@ $^

Queue: $(BIN)/Queue
$(BIN)/Queue: $(OBJ)/Queue.o
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ)/%.o : strutture_dati/%.c strutture_dati/headers/%.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -f -r $(BIN) $(OBJ)
