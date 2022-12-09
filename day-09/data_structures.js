"use strict";

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

export { point, set };
