#ifndef __point_header__
#define __point_header__

typedef struct Point {
    int i;
    int j;
} Point;

typedef struct Step {
    Point point;
    int count;
} Step;

#endif
