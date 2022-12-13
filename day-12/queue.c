#include "queue.h"
#include "stdlib.h"

typedef struct StepNode {
    Step step;
    struct StepNode* next;
} StepNode;

typedef struct StepQueue {
    StepNode* head;
    StepNode* tail;
} StepQueue;


StepQueue* createQueue()
{
    return (StepQueue*)malloc(sizeof(StepQueue));
}

void destroyQueue(StepQueue* q)
{
    StepNode* node = q->head;
    while (node != NULL) {
        StepNode* next = node->next;
        free(node);
        node = next;
    }
    free(q);
}

void enqueue(StepQueue* q, Step step)
{
    StepNode* newNode = (StepNode*)malloc(sizeof(StepNode));
    newNode->step = step;
    newNode->next = NULL;

    if (q->head == NULL) {
        q->head = newNode;
        q->tail = newNode;
    }
    else {
        q->tail->next = newNode;
        q->tail = newNode;
    }
}

Step dequeue(StepQueue* q)
{
    Step step = q->head->step;
    q->head = q->head->next;

    return step;
}
