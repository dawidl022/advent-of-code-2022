from elves import parseInput, move


if __name__ == "__main__":
    elves = parseInput()
    finished = False
    i = 0

    while not finished:
        elves, finished = move(elves, i)
        i += 1

    print(i)
