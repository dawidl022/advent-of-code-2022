def calc_score(rounds: list[tuple[str, str]]) -> int:
    score = 0
    for round in rounds:
        score += points_for_selection(round)
        if is_winning_combo(round):
            score += 6
        elif is_draw_combo(round):
            score += 3

    return score


def points_for_selection(round):
    return ord(round[1]) - ord('X') + 1


def is_winning_combo(round: tuple[str, str]) -> bool:
    return round[0] == 'A' and round[1] == 'Y' \
        or round[0] == 'B' and round[1] == 'Z' \
        or round[0] == 'C' and round[1] == 'X'


def is_draw_combo(round: tuple[str, str]) -> bool:
    return ord(round[0]) - ord('A') == ord(round[1]) - ord('X')


if __name__ == "__main__":
    lines = []
    while True:
        try:
            lines.append(input().split())
        except EOFError:
            break
    print(calc_score(lines))
