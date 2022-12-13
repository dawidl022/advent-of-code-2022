"use strict";

import fs from "fs";

import { PacketArr, PacketPair } from "./types.js";

const parsePacketPairs = (): PacketPair[] => {
  const lines = fs.readFileSync(process.argv[2], "utf8").trim().split("\n");
  const pairs: PacketPair[] = [];

  for (let i = 0; i < lines.length; i += 3) {
    pairs.push({
      first: eval(lines[i]),
      second: eval(lines[i + 1]),
    });
  }
  return pairs;
};

const parsePackets = (): PacketArr[] => {
  const lines = fs.readFileSync(process.argv[2], "utf8").trim().split("\n");
  const packets: PacketArr[] = [];

  for (let i = 0; i < lines.length; i += 3) {
    packets.push(eval(lines[i]));
    packets.push(eval(lines[i + 1]));
  }
  return packets;
};

export { parsePacketPairs, parsePackets };
