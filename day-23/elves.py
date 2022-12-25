from collections import defaultdict
from typing import Iterable, NamedTuple


class Point(NamedTuple):
    x: int
    y: int

    def adjacent_points(self) -> Iterable['Point']:
        return (self + dir for dir in ALL_DIRECTIONS)

    def __add__(self, other) -> 'Point':
        return Point(self.x + other.x, self.y + other.y)


NORTH = Point(0, -1)
NORTH_EAST = Point(1, -1)
EAST = Point(1, 0)
SOUTH_EAST = Point(1, 1)
SOUTH = Point(0, 1)
SOUTH_WEST = Point(-1, 1)
WEST = Point(-1, 0)
NORTH_WEST = Point(-1, -1)

ALL_DIRECTIONS = (
    NORTH,
    NORTH_EAST,
    EAST,
    SOUTH_EAST,
    SOUTH,
    SOUTH_WEST,
    WEST,
    NORTH_WEST
)


def parseInput() -> set[Point]:
    elves: set[Point] = set()
    j = 0

    while True:
        try:
            line = input()
            for i, char in enumerate(line):
                if char == "#":
                    elves.add(Point(i, j))
            j += 1
        except EOFError:
            break

    return elves


def move(elves: set[Point], round: int) -> tuple[set[Point], bool]:
    propositions: dict[Point, list[Point]] = defaultdict(list)

    for elf in elves:
        if all(adj not in elves for adj in elf.adjacent_points()):
            pass
        else:
            for directions in arrange_per_round((
                (NORTH, NORTH_EAST, NORTH_WEST),
                (SOUTH, SOUTH_EAST, SOUTH_WEST),
                (WEST, NORTH_WEST, SOUTH_WEST),
                (EAST, NORTH_EAST, SOUTH_EAST),
            ), round):
                if all(elf + d not in elves for d in directions):
                    propositions[elf + directions[0]].append(elf)
                    break

    for target, candidates in propositions.items():
        if len(candidates) == 1:
            elves.add(target)
            elves.remove(candidates[0])

    return elves, len(propositions) == 0


def arrange_per_round(directions: tuple[tuple[Point, Point, Point], ...], round: int) \
        -> tuple[tuple[Point, Point, Point], ...]:
    round = round % 4
    return directions[round:] + directions[:round]
