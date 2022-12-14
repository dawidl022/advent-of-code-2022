#ifndef __point_header__
#define __point_header__

#include <unordered_set>
#include <vector>


struct Point {
    int x;
    int y;

    bool operator==(const Point& other) const
    {
        return x == other.x && y == other.y;
    };

    size_t operator()(const Point& p) const
    {
        return (p.x << 2) + p.y;
    }
};

Point createPointFromCoordString(char* str)
{
    Point p;
    int curr = 0;

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == ',') {
            p.x = curr;
            curr = 0;
        }
        else {
            curr *= 10;
            curr += str[i] - '0';
        }
    }
    p.y = curr;
    return p;
}

void updateMinPoint(Point& min_point, Point& point)
{
    if (point.y > min_point.y) {
        min_point.x = point.x;
        min_point.y = point.y;
    }
}

void insertPoint(std::unordered_set<Point, Point>& points, Point& min_point, int x, int y)
{
    Point p = { .x = x, .y = y };
    points.insert(p);
    updateMinPoint(min_point, p);
}

void insertPointsOnLines(std::unordered_set<Point, Point>& points, std::vector<Point>& input_points, Point& min_point)
{
    for (int i = 0; i < input_points.size() - 1; i++) {
        Point a = input_points.at(i);
        Point b = input_points.at(i + 1);

        insertPoint(points, min_point, a.x, a.y);
        insertPoint(points, min_point, b.x, b.y);

        for (int i = a.x + 1; i < b.x; i++) {
            insertPoint(points, min_point, i, a.y);
        }
        for (int i = b.x + 1; i < a.x; i++) {
            insertPoint(points, min_point, i, a.y);
        }
        for (int i = a.y + 1; i < b.y; i++) {
            insertPoint(points, min_point, a.x, i);
        }
        for (int i = b.y + 1; i < a.y; i++) {
            insertPoint(points, min_point, a.x, i);
        }
    }
}
#endif
