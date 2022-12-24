from collections import deque
from typing import Callable, NamedTuple
import operator


class MonkeyOperation(NamedTuple):
    identity: str
    operation: Callable[[int, int], int]
    leftOperand: str
    rightOperand: str


def parseOperator(opChar: str) -> Callable[[int, int], int]:
    if opChar == "+":
        return operator.add
    if opChar == "-":
        return operator.sub
    if opChar == "*":
        return operator.mul
    if opChar == "/":
        return operator.floordiv
    else:
        raise Exception("Unexpected operator")


if __name__ == "__main__":
    monkeyValues: dict[str, int] = {}
    monkeyQueue: deque[MonkeyOperation] = deque()

    while True:
        try:
            raw_data = input().split()
            identity = raw_data[0][:4]
            if len(raw_data) == 2:
                monkeyValues[identity] = int(raw_data[1])
            else:
                monkeyQueue.append(
                    MonkeyOperation(
                        identity=identity,
                        operation=parseOperator(raw_data[2]),
                        leftOperand=raw_data[1],
                        rightOperand=raw_data[3],
                    )
                )
        except EOFError:
            break

    while len(monkeyQueue) > 0:
        op = monkeyQueue.pop()
        if op.leftOperand in monkeyValues and op.rightOperand in monkeyValues:
            monkeyValues[op.identity] = op.operation(
                monkeyValues[op.leftOperand], monkeyValues[op.rightOperand])
        else:
            monkeyQueue.appendleft(op)

    print(monkeyValues["root"])
