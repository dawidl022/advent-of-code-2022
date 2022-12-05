from typing import NamedTuple


class Instruction(NamedTuple):
    quantity: int
    source: int
    target: int
