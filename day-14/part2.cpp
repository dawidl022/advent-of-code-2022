#include <unordered_set>
#include <iostream>
#include "./point.cpp"
#include "./parse_input.cpp"

int main()
{
    Point min_point = { .x = -1, .y = -1 };

    std::unordered_set<Point, Point> points;

    parseInput(points, min_point);

    const Point sand_source = { .x = 500, .y = 0 };

    Point sand_unit = { .x = sand_source.x, .y = sand_source.y };
    int sand_count = 0;

    while (points.find(sand_source) == points.end()) {
        Point p = { .x = sand_unit.x, .y = sand_unit.y + 1 };

        if (p.y == min_point.y + 2) {
            points.insert(sand_unit);
            sand_count++;
            sand_unit = sand_source;
        }
        else if (points.find(p) == points.end()) {
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
