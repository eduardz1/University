#pragma once

#include <stdbool.h>
#include <stdint.h>
#include "../common.h"
/**
 * @brief stack of Coordinate type elements
 *
 */
struct Stack
{
    struct Coordinate *elems;
    uint32_t size;
    int32_t top;
};

void stack_init(struct Stack *stack, uint32_t size);
void push(struct Stack *stack, uint16_t x, uint16_t y);
struct Coordinate pop(struct Stack *stack);
bool is_empty(struct Stack *stack);
void free_stack(struct Stack *stack);
