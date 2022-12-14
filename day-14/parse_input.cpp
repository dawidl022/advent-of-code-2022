#include <unordered_set>
#include <vector>
#include <iostream>
#include "./point.cpp"

void parseInput(std::unordered_set<Point, Point>& points, Point& min_point)
{
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
}
