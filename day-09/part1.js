"use strict";

import { parseInput } from "./parse_input.js";
import { point, set } from "./data_structures.js";
import { areTouching, moveTowards } from "./logic.js";

(() => {
  const visited = set();
  let head = point(0, 0);
  let tail = point(0, 0);

  visited.add(tail);

  const instructions = parseInput();

  for (let j = 0; j < instructions.length; j++) {
    const direction = instructions[j][0];
    const steps = parseInt(instructions[j][1]);

    for (let i = 0; i < steps; i++) {
      switch (direction) {
        case "R":
          head = point(head.getX() + 1, head.getY());
          break;
        case "L":
          head = point(head.getX() - 1, head.getY());
          break;
        case "U":
          head = point(head.getX(), head.getY() + 1);
          break;
        case "D":
          head = point(head.getX(), head.getY() - 1);
          break;
        default:
          throw "Invalid direction!";
      }

      if (!areTouching(head, tail)) {
        tail = moveTowards(tail, head);
        visited.add(tail);
      }
    }
  }
  console.log(visited.getSize());
})();
