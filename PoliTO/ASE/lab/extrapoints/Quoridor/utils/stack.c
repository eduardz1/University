#include "stack.h"
#include <stdint.h>
#include <stdlib.h>

void stack_init(struct Stack *stack, uint32_t size)
{
    stack->elems = malloc(size * sizeof(struct Coordinate));
    stack->size = size;
    stack->top = -1;
}

void push(struct Stack *stack, uint16_t x, uint16_t y)
{
    if (stack->top >= (int32_t)stack->size - 1) return; // stack full

    stack->elems[++stack->top].x = x;
    stack->elems[stack->top].y = y;
}

struct Coordinate pop(struct Stack *stack)
{
    return (stack->top >= 0) ? stack->elems[stack->top--] :
                               (struct Coordinate){0}; // default to 0
}

bool is_empty(struct Stack *stack)
{
    return stack->top == -1;
}

void free_stack(struct Stack *stack)
{
    free(stack->elems);
}
