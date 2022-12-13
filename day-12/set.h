#include "./point.c"


typedef struct PointSet PointSet;

PointSet* createSet();

void add(PointSet* s, Point point);

int contains(PointSet* s, Point point);
