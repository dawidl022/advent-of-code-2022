read_stream :-
    read_line_to_codes(user_input, Codes, _),
    [H|T] = Codes,
    process_elf1_start(H, T, 0, 0).

process_elf1_start(end_of_file, _, _, DuplicateCount) :-
    write(DuplicateCount).

parse_char(X, Num) :- Num is X - 48.

process_elf1_start(X, R, Elf1Start, DuplicateCount) :-
    is_digit(X),
    [H|T] = R,
    parse_char(X, Num),
    process_elf1_start(H, T, Elf1Start * 10 + Num, DuplicateCount).

process_elf1_start(X, R, Elf1Start, DuplicateCount) :-
    \+ is_digit(X),
    [H|T] = R,
    process_elf1_end(H, T, Elf1Start, 0, DuplicateCount).

process_elf1_end(X, R, Elf1Start, Elf1End, DuplicateCount) :-
    is_digit(X),
    [H|T] = R,
    parse_char(X, Num),
    process_elf1_end(H, T, Elf1Start, Elf1End * 10 + Num, DuplicateCount).

process_elf1_end(X, R, Elf1Start, Elf1End, DuplicateCount) :-
    \+ is_digit(X),
    [H|T] = R,
    process_elf2_start(H, T, Elf1Start, Elf1End, 0, DuplicateCount).

process_elf2_start(X, R, Elf1Start, Elf1End, Elf2Start, DuplicateCount) :-
    is_digit(X),
    [H|T] = R,
    parse_char(X, Num),
    process_elf2_start(H, T, Elf1Start, Elf1End, Elf2Start * 10 + Num, DuplicateCount).

process_elf2_start(X, R, Elf1Start, Elf1End, Elf2Start, DuplicateCount) :-
    \+ is_digit(X),
    [H|T] = R,
    process_elf2_end(H, T, Elf1Start, Elf1End, Elf2Start, 0, DuplicateCount).

process_elf2_end(X, R, Elf1Start, Elf1End, Elf2Start, Elf2End, DuplicateCount) :-
    is_digit(X),
    [H|T] = R,
    parse_char(X, Num),
    process_elf2_end(H, T, Elf1Start, Elf1End, Elf2Start, Elf2End * 10 + Num, DuplicateCount).

process_elf2_end(X, R, Elf1Start, Elf1End, Elf2Start, Elf2End, DuplicateCount) :-
    \+ is_digit(X),
    process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsDuplicate),
    Sum is DuplicateCount + IsDuplicate,
    write(Sum),
    read_line_to_codes(user_input, Codes, _),
    [H|T] = Codes,
    process_elf1_start(H, T, 0, DuplicateCount + IsDuplicate).
