#include "stdlib.h"
#include "set.h"

typedef struct PointArray PointArray;

typedef struct PointSet {
    PointArray* arr;
} PointSet;

typedef struct PointArray {
    Point* arr;
    int len;
    int cap;
} PointArray;

PointArray* createPointArray()
{
    PointArray* array = malloc(sizeof(PointArray));
    array->arr = malloc(sizeof(Point) * 10);
    array->len = 0;
    array->cap = 10;

    return array;
}


void appendPoint(PointArray* a, Point point)
{
    if (a->len == a->cap) {
        Point* newArr = malloc(sizeof(Point) * a->cap * 2);

        for (int i = 0; i < a->len; i++) {
            newArr[i] = a->arr[i];
        }
        a->arr = newArr;
        a->cap *= 2;
    }
    a->arr[a->len++] = point;
}

PointSet* createSet()
{
    PointSet* set = malloc(sizeof(PointSet));
    set->arr = createPointArray();
    return set;
}

void add(PointSet* set, Point point)
{
    for (int i = 0; i < set->arr->len; i++) {
        Point p = set->arr->arr[i];
        if (p.i == point.i && p.j == point.j) {
            return;
        }
    }
    appendPoint(set->arr, point);
}

int contains(PointSet* set, Point point)
{
    for (int i = 0; i < set->arr->len; i++) {
        Point p = set->arr->arr[i];
        if (p.i == point.i && p.j == point.j) {
            return 1;
        }
    }
    return 0;
}
