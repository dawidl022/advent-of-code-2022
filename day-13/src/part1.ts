"use strict";

import { parsePacketPairs } from "./parse_input.js";
import { isInRightOrder } from "./comparator.js";
import { PacketPair } from "./types.js";

const isPairInRightOrder = (pair: PacketPair): boolean => {
  return isInRightOrder(pair.first, pair.second) === 1;
};

(() => {
  const packetPairs: PacketPair[] = parsePacketPairs();
  let indices: number[] = [];

  packetPairs.forEach((pair, i) => {
    if (isPairInRightOrder(pair)) {
      indices.push(i + 1);
    }
  });

  const result = indices.reduce((total, index) => total + index);
  console.log(result);
})();
