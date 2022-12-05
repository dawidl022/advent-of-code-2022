from collections import deque

from model.instruction import Instruction
from util.run import run


def process_instructions(stacks: list[deque[str]], instructions: list[Instruction]) -> str:
    for inst in instructions:
        source = stacks[inst.source - 1]
        target = stacks[inst.target - 1]

        tmp = deque()

        for _ in range(inst.quantity):
            tmp.append(source.popleft())

        for _ in range(inst.quantity):
            target.appendleft(tmp.pop())

    return "".join([st[0] for st in stacks])


if __name__ == "__main__":
    run(process_instructions)
