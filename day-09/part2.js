"use strict";

const fs = require("fs");

const point = (x, y) => {
  const equals = other => {
    return x == other.getX() && y == other.getY();
  };

  const getX = () => {
    return x;
  };

  const getY = () => {
    return y;
  };

  return {
    getX,
    getY,
    equals,
  };
};

// very inefficient set implementation, but works for today's challenge :)
const set = () => {
  let arr = [];

  let add = el => {
    for (let i = 0; i < arr.length; i++) {
      if (arr[i].equals(el)) {
        return;
      }
    }
    arr.push(el);
  };

  let getSize = () => arr.length;
  return {
    add,
    getSize,
  };
};

const areTouching = (point1, point2) =>
  point2.getX() <= point1.getX() + 1 &&
  point2.getX() >= point1.getX() - 1 &&
  point2.getY() <= point1.getY() + 1 &&
  point2.getY() >= point1.getY() - 1;

const sign = x => {
  if (x < 0) {
    return -1;
  }
  if (x == 0) {
    return 0;
  }
  return 1;
};

const moveTowards = (source, target) => {
  if (source.getX() == target.getX()) {
    const move = sign(target.getY() - source.getY());
    return point(source.getX(), source.getY() + move);
  }
  if (source.getY() == target.getY()) {
    const move = sign(target.getX() - source.getX());
    return point(source.getX() + move, source.getY());
  }
  if (target.getX() > source.getX() && target.getY() > source.getY()) {
    return point(source.getX() + 1, source.getY() + 1);
  }
  if (target.getX() > source.getX()) {
    return point(source.getX() + 1, source.getY() - 1);
  }
  if (target.getX() < source.getX() && target.getY() < source.getY()) {
    return point(source.getX() - 1, source.getY() - 1);
  } else {
    return point(source.getX() - 1, source.getY() + 1);
  }
};

(() => {
  const visited = set();
  let knots = Array.apply(null, Array(10)).map(_ => point(0, 0));

  visited.add(knots[9]);

  const input = fs.readFileSync(process.argv[2], "utf8");
  const instructions = input
    .trim("\n")
    .split("\n")
    .map(x => x.split(" "));

  for (let j = 0; j < instructions.length; j++) {
    const direction = instructions[j][0];
    const steps = parseInt(instructions[j][1]);
    for (let i = 0; i < steps; i++) {
      const head = knots[0];
      switch (direction) {
        case "R":
          knots[0] = point(head.getX() + 1, head.getY());
          break;
        case "L":
          knots[0] = point(head.getX() - 1, head.getY());
          break;
        case "U":
          knots[0] = point(head.getX(), head.getY() + 1);
          break;
        case "D":
          knots[0] = point(head.getX(), head.getY() - 1);
          break;
        default:
          throw "Invalid direction!";
      }

      for (let k = 0; k < 9; k++) {
        const head = knots[k];
        let tail = knots[k + 1];

        if (!areTouching(head, tail)) {
          tail = moveTowards(tail, head);
          knots[k + 1] = tail;

          if (k == 8) {
            visited.add(tail);
          }
        }
      }
    }
  }
  console.log(visited.getSize());
})();
