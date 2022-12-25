from blizzard import parse_input, minimum_minutes_to_exit

if __name__ == "__main__":
    blizzards, wall, start_point, end_point = parse_input()
    total_count = 0

    count, blizzards = minimum_minutes_to_exit(
        blizzards, wall, start_point, end_point)
    total_count += count

    count, blizzards = minimum_minutes_to_exit(
        blizzards, wall, end_point, start_point)
    total_count += count

    count, blizzards = minimum_minutes_to_exit(
        blizzards, wall, start_point, end_point)
    total_count += count

    print(total_count)
