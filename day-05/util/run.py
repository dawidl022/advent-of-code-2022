import re
from collections import deque
from typing import Callable

from model.instruction import Instruction


def run(solution: Callable[[list[deque[str]], list[Instruction]], str]):
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

    print(solution(stacks, instructions))
