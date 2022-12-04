process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsDuplicate) :-
    Elf1Start =< Elf2Start,
    Elf1End >= Elf2End,
    IsDuplicate is 1.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsDuplicate) :-
    Elf1Start >= Elf2Start,
    Elf1End =< Elf2End,
    IsDuplicate is 1.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsDuplicate) :-
    IsDuplicate is 0.
