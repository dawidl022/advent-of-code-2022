from collections import deque
from typing import Callable, NamedTuple
import operator


class MonkeyOperation(NamedTuple):
    identity: str
    operation: Callable[[int, int], int]
    leftOperand: str
    rightOperand: str


class HumanOperation(NamedTuple):
    operation: Callable[[int, int], int]
    operand: int
    isLeft: bool


class HumanValue:
    def __init__(self, operations: list[HumanOperation]):
        self.operations = operations

    def __add__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.add, other, True)])

    def __radd___(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.add, other, False)])

    def __sub__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.sub, other, True)])

    def __rsub__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.sub, other, False)])

    def __mul__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.mul, other, True)])

    def __rmul__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.mul, other, False)])

    def __floordiv__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.floordiv, other, True)])

    def __rfloordiv__(self, other: int) -> 'HumanValue':
        return HumanValue(self.operations + [HumanOperation(operator.floordiv, other, False)])

    def rightOp(self, op: Callable[[int, int], int], other) -> 'HumanValue':
        if op == operator.add:
            return self.__radd___(other)
        elif op == operator.sub:
            return self.__rsub__(other)
        elif op == operator.mul:
            return self.__rmul__(other)
        elif op == operator.floordiv:
            return self.__rfloordiv__(other)
        raise Exception("Unexpected operator")

    def unwind(self) -> int:
        result = 0

        for op in reversed(self.operations):
            if (op.operation == operator.sub or op.operation == operator.truediv) and not op.isLeft:
                result = op.operation(op.operand, result)
            else:
                result = inverseOperator(op.operation)(result, op.operand)

        return result


def parseOperator(opChar: str) -> Callable[[int, int], int]:
    if opChar == "+":
        return operator.add
    if opChar == "-":
        return operator.sub
    if opChar == "*":
        return operator.mul
    if opChar == "/":
        return operator.floordiv
    raise Exception("Unexpected operator")


def inverseOperator(op: Callable[[int, int], int]) -> Callable[[int, int], int]:
    if op == operator.add:
        return operator.sub
    if op == operator.sub:
        return operator.add
    if op == operator.mul:
        return operator.floordiv
    if op == operator.floordiv:
        return operator.mul
    raise Exception("Unexpected operator")


if __name__ == "__main__":
    monkeyValues: dict[str, int] = {}
    monkeyQueue: deque[MonkeyOperation] = deque()

    while True:
        try:
            raw_data = input().split()
            identity = raw_data[0][:4]
            if identity == "humn":
                monkeyValues[identity] = HumanValue([])
            elif len(raw_data) == 2:
                monkeyValues[identity] = int(raw_data[1])
            elif identity == "root":
                monkeyQueue.append(
                    MonkeyOperation(
                        identity=identity,
                        operation=lambda x, y: x - y,
                        leftOperand=raw_data[1],
                        rightOperand=raw_data[3],
                    )
                )
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
            # necessary to handle Int <op> HumanValue case explicitly as Python
            # will attempt to do Int.__<op>__, rather than HumanValue.__r<op>__
            if isinstance(monkeyValues[op.rightOperand], HumanValue):
                monkeyValues[op.identity] = monkeyValues[op.rightOperand].rightOp(
                    op.operation, monkeyValues[op.leftOperand])
            else:
                monkeyValues[op.identity] = op.operation(
                    monkeyValues[op.leftOperand], monkeyValues[op.rightOperand])
        else:
            monkeyQueue.appendleft(op)

    print(monkeyValues["root"].unwind())
