from collections import Counter, deque
from typing import NamedTuple


class Point(NamedTuple):
    x: int
    y: int

    def __add__(self, other) -> 'Point':
        return Point(self.x + other.x, self.y + other.y)


UP = Point(0, -1)
RIGHT = Point(1, 0)
DOWN = Point(0, 1)
LEFT = Point(-1, 0)

ARROWS_TO_DIR = {
    "^": UP,
    ">": RIGHT,
    "v": DOWN,
    "<": LEFT,
}


class Wall(NamedTuple):
    right_x: int
    bottom_y: int
    top_exit: Point
    bottom_exit: Point

    def __contains__(self, p: Point) -> bool:
        return p not in (self.bottom_exit, self.top_exit) and (p.x == 0 or p.y == 0 or p.x == self.right_x or p.y == self.bottom_y)


class Blizzard(NamedTuple):
    position: Point
    direction: Point

    def move(self, wall: Wall) -> 'Blizzard':
        new_pos = self.position + self.direction

        if new_pos.x == 0:
            new_pos = Point(wall.right_x - 1, new_pos.y)
        elif new_pos.x == wall.right_x:
            new_pos = Point(1, new_pos.y)
        elif new_pos.y == 0:
            new_pos = Point(new_pos.x, wall.bottom_y - 1)
        elif new_pos.y == wall.bottom_y:
            new_pos = Point(new_pos.x, 1)

        return Blizzard(new_pos, self.direction)


def minimum_minutes_to_exit(blizzards: set[Blizzard], wall: Wall, start: Point, target: Point) \
        -> tuple[int, set[Blizzard]]:

    curr_turn: set[Point] = set((start,))
    next_turn: set[Point] = set()
    turn_count = 0

    while True:
        prev_blizzards = blizzards
        blizzards = set(blizzard.move(wall) for blizzard in blizzards)
        blizzard_positions = set(blizzard.position for blizzard in blizzards)

        for point in curr_turn:
            if point == target:
                return turn_count, prev_blizzards

            if point not in blizzard_positions:
                next_turn.add(point)

            moves = point + UP, point + RIGHT, point + DOWN, point + LEFT
            for move in moves:
                if move not in wall and move not in blizzard_positions:
                    next_turn.add(move)

        curr_turn = next_turn
        next_turn = set()
        turn_count += 1


def parse_input() -> tuple[set[Blizzard], Wall, Point, Point]:
    start_line = input()
    start_point = Point(start_line.index("."), 0)

    y = 1
    blizzards: set[Blizzard] = set()

    while True:
        line = input()
        if Counter(line)["#"] > 2:
            end_point = Point(line.index("."), y)
            break

        for i, char in enumerate(line):
            if char in ("^", ">", "v", "<"):
                blizzards.add(Blizzard(Point(i, y), ARROWS_TO_DIR[char]))

        y += 1

    return blizzards, Wall(len(line) - 1, y, start_point, end_point), start_point, end_point
