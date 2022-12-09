"use strict";

import fs from "fs";

const parseInput = () =>
  fs
    .readFileSync(process.argv[2], "utf8")
    .trim("\n")
    .split("\n")
    .map(x => x.split(" "));

export { parseInput };
