from elves import parseInput, move, Point


def number_of_empty_tiles_around(elves: set[Point]) -> int:
    max_n = None
    max_e = None
    max_s = None
    max_w = None

    for elf in elves:
        if max_n is None or elf.y < max_n:
            max_n = elf.y
        if max_e is None or elf.x > max_e:
            max_e = elf.x
        if max_s is None or elf.y > max_s:
            max_s = elf.y
        if max_w is None or elf.x < max_w:
            max_w = elf.x

    return (max_s - max_n + 1) * (max_e - max_w + 1) - len(elves)


if __name__ == "__main__":
    elves = parseInput()

    for i in range(10):
        elves, _ = move(elves, i)

    print(number_of_empty_tiles_around(elves))
