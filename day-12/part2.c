#include "stdio.h"
#include "./queue.h"
#include "./set.h"
#include "./array.c"


void enqueuePointIfNotVisited(Array* lines, StepQueue* queue, PointSet* set, int i, int j, char maxChar, int count);

void enqueueNeighboursIfAtMost(Array* lines, StepQueue* queue, PointSet* set, int i, int j, char maxChar, int count)
{
    if (i > 0) {
        // we can do up
        enqueuePointIfNotVisited(lines, queue, set, i - 1, j, maxChar, count);
    }
    if (i < lines->len - 1) {
        // we can do down
        enqueuePointIfNotVisited(lines, queue, set, i + 1, j, maxChar, count);
    }
    if (j > 0) {
        // we can do left
        enqueuePointIfNotVisited(lines, queue, set, i, j - 1, maxChar, count);
    }

    if (lines->arr[i][j + 1] != '\0') {
        enqueuePointIfNotVisited(lines, queue, set, i, j + 1, maxChar, count);
        // we can do right
    }
}

void enqueuePointIfNotVisited(Array* lines, StepQueue* queue, PointSet* set, int i, int j, char maxChar, int count)
{
    if (lines->arr[i][j] != 'E' && lines->arr[i][j] <= maxChar || maxChar >= 'z') {
        Point point = { .i = i, .j = j };
        if (contains(set, point) == 0) {
            add(set, point);
            Step step = { .point = point, .count = count };
            enqueue(queue, step);
        }
    }
}

int main()
{
    Array* lines = createArray();
    StepQueue* q = createQueue();
    PointSet* set = createSet();

    while (!feof(stdin)) {
        char* line = NULL;
        size_t len = 0;

        getline(&line, &len, stdin);
        if (len > 1) {
            append(lines, line);
        }
    }

    for (int i = 0; i < lines->len; i++) {
        for (int j = 0; lines->arr[i][j] != '\0'; j++) {
            if (lines->arr[i][j] == 'a') {
                Point origin = { .i = i, .j = j };
                add(set, origin);
                enqueueNeighboursIfAtMost(lines, q, set, i, j, 'b', 1);
            }
        }
    }

    while (1) {
        Step step = dequeue(q);
        char letter = lines->arr[step.point.i][step.point.j];
        if (letter == 'E') {
            printf("%i\n", step.count);
            break;
        }
        enqueueNeighboursIfAtMost(lines, q, set, step.point.i, step.point.j, letter + 1, step.count + 1);
    }
}
