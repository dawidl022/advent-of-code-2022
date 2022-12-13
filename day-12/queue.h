#include "./point.c"

typedef struct StepQueue StepQueue;

StepQueue* createQueue();
void destroyQueue(StepQueue* q);

void enqueue(StepQueue* q, Step step);
Step dequeue(StepQueue* q);
