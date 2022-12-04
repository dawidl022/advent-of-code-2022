process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf1End < Elf2Start,
    Elf1Start < Elf2Start,
    IsOverlapping is 0.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf2End < Elf1Start,
    Elf2Start < Elf1Start,
    IsOverlapping is 0.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf1Start =< Elf2Start,
    Elf1End >= Elf2Start,
    IsOverlapping is 1.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf2Start =< Elf1Start,
    Elf2End >= Elf1Start,
    IsOverlapping is 1.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf1Start =< Elf2Start,
    Elf1End >= Elf2End,
    IsOverlapping is 1.

process_elf(Elf1Start, Elf1End, Elf2Start, Elf2End, IsOverlapping) :-
    Elf2Start =< Elf1Start,
    Elf2End >= Elf1End,
    IsOverlapping is 1.
