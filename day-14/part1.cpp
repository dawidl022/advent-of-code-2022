#include <unordered_set>
#include <iostream>
#include <cstring>
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

void insertPointsOnLines(std::unordered_set<Point, Point>& points, std::vector<Point>& input_points, Point& min_point)
{
    for (int i = 0; i < input_points.size() - 1; i++) {
        Point a = input_points.at(i);
        Point b = input_points.at(i + 1);

        points.insert(a);
        points.insert(b);

        if (a.x < b.x) {
            for (int i = a.x + 1; i < b.x; i++) {
                Point p = { .x = i, .y = a.y };
                points.insert(p);
                updateMinPoint(min_point, p);
            }
        }
        else if (a.x > b.x) {
            for (int i = b.x + 1; i < a.x; i++) {
                Point p = { .x = i, .y = a.y };
                points.insert(p);
                updateMinPoint(min_point, p);
            }
        }
        else if (a.y < b.y) {
            for (int i = a.y + 1; i < b.y; i++) {
                Point p = { .x = a.x, .y = i };
                points.insert(p);
                updateMinPoint(min_point, p);
            }
        }
        else if (a.y > b.y) {
            for (int i = b.y + 1; i < a.y; i++) {
                Point p = { .x = a.x, .y = i };
                points.insert(p);
                updateMinPoint(min_point, p);
            }
        }
    }
}

int main()
{
    Point min_point = { .x = -1, .y = -1 };

    std::unordered_set<Point, Point> points;

    while (!std::cin.eof()) {
        std::string line;
        std::getline(std::cin, line);

        std::vector<Point> input_points;

        char* cline = new char[line.length() + 1];
        strcpy(cline, line.c_str());

        char* token = strtok(cline, " -> ");

        while (token != NULL) {

            input_points.push_back(createPointFromCoordString(token));

            token = strtok(NULL, " -> ");
        }

        if (input_points.size() > 0) {
            insertPointsOnLines(points, input_points, min_point);
        }
    }

    const Point sand_source = { .x = 500, .y = 0 };

    Point sand_unit = { .x = sand_source.x, .y = sand_source.y };
    int sand_count = 0;

    while (sand_unit.y < min_point.y) {
        Point p = { .x = sand_unit.x, .y = sand_unit.y + 1 };
        if (points.find(p) == points.end()) {
            sand_unit = p;
        }
        else {
            p.x -= 1;
            if (points.find(p) == points.end()) {
                sand_unit = p;
            }
            else {
                p.x += 2;
                if (points.find(p) == points.end()) {
                    sand_unit = p;
                }
                else {
                    points.insert(sand_unit);
                    sand_count++;
                    sand_unit = sand_source;
                }
            }
        }
    }

    std::cout << sand_count << '\n';

    return 0;
}
