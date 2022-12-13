#ifndef __array_header__
#define __array_header__

#include "stdlib.h"

typedef struct {
    char** arr;
    int len;
    int cap;
} Array;

Array* createArray()
{
    Array* array = malloc(sizeof(Array));
    array->arr = malloc(sizeof(char*) * 10);
    array->len = 0;
    array->cap = 10;

    return array;
}


void append(Array* a, char* chars)
{
    if (a->len == a->cap) {
        char** newArr = malloc(sizeof(char*) * a->cap * 2);

        for (int i = 0; i < a->len; i++) {
            newArr[i] = a->arr[i];
        }
        a->arr = newArr;
        a->cap *= 2;
    }
    a->arr[a->len++] = chars;
}

#endif
