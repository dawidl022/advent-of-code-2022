"use strict";

import { parseInput } from "./parse_input.js";
import { point, set } from "./data_structures.js";
import { areTouching, moveTowards } from "./logic.js";

(() => {
  const visited = set();
  const knots = Array.apply(null, Array(10)).map(_ => point(0, 0));

  visited.add(knots[9]);

  const instructions = parseInput();

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
