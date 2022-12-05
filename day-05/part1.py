from typing import NamedTuple
from collections import deque

import re


class Instruction(NamedTuple):
    quantity: int
    source: int
    target: int


def process_instructions(stacks: list[deque[str]], instructions: list[Instruction]) -> str:
    for inst in instructions:
        source = stacks[inst.source - 1]
        target = stacks[inst.target - 1]

        for _ in range(inst.quantity):
            target.appendleft(source.popleft())

    return "".join([st[0] for st in stacks])


if __name__ == "__main__":
    stacks: list[deque[str]] = []
    instructions: list[Instruction] = []
    instruction_re = "move ([0-9]*) from ([0-9]*) to ([0-9]*)"
    parse_instructions = False
    while True:
        try:
            raw_input = input()
            if parse_instructions:
                raw_instruction = re.search(instruction_re, raw_input)
                instructions.append(
                    Instruction(*(int(x) for x in raw_instruction.groups()))
                )
            else:
                if len(raw_input) == 0:
                    parse_instructions = True
                else:
                    for i in range(1, len(raw_input) + 1, 4):
                        stack_index = i // 4
                        if stack_index >= len(stacks):
                            stacks.append(deque())
                        if raw_input[i].isalpha():
                            stacks[stack_index].append(raw_input[i])
        except EOFError:
            break
    print(process_instructions(stacks, instructions))
