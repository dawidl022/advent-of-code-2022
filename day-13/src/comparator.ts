import { PacketArr } from "./types.js";

const sign = (n: number): number => {
  if (n > 0) {
    return 1;
  }
  if (n === 0) {
    return 0;
  }
  return -1;
};

const isInRightOrder = (
  first: PacketArr | number,
  second: PacketArr | number
): number => {
  if (typeof first === "number" && typeof second === "number") {
    if (first < second) {
      return 1;
    }
    if (first > second) {
      return -1;
    }
    return 0;
  }

  if (typeof first === "number") {
    first = [first];
  }
  if (typeof second === "number") {
    second = [second];
  }

  const n = first.length < second.length ? first.length : second.length;
  for (let i = 0; i < n; i++) {
    const result = isInRightOrder(first[i], second[i]);
    if (result !== 0) {
      return result;
    }
  }

  return sign(second.length - first.length);
};

export { isInRightOrder };
