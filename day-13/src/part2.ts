"use strict";

import { parsePackets } from "./parse_input.js";
import { isInRightOrder } from "./comparator.js";
import { PacketArr } from "./types.js";

(() => {
  const packets: PacketArr[] = parsePackets();

  const divisor1 = [[2]];
  const divisor2 = [[6]];
  packets.push(divisor1);
  packets.push(divisor2);

  packets.sort((a, b) => -isInRightOrder(a, b));
  const result =
    (packets.indexOf(divisor1) + 1) * (packets.indexOf(divisor2) + 1);

  console.log(result);
})();
