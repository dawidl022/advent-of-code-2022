"use strict";

import { point } from "./data_structures.js";

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

export { areTouching, moveTowards };
