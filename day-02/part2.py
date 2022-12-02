def calc_score(rounds: list[tuple[str, str]]) -> int:
    score = 0
    for round in rounds:
        opponent = ord(round[0]) - ord('A')
        if round[1] == 'X':
            player = loosing_piece_to(opponent)
        elif round[1] == 'Z':
            player = winning_piece_to(opponent)
            score += 6
        else:
            player = opponent
            score += 3
        score += 1 + player

    return score


def loosing_piece_to(opponent_piece: int) -> int:
    return (opponent_piece - 1) % 3


def winning_piece_to(opponent_piece: int) -> int:
    return (opponent_piece + 1) % 3


if __name__ == "__main__":
    lines = []
    while True:
        try:
            lines.append(input().split())
        except EOFError:
            break
    print(calc_score(lines))
