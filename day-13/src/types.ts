type PacketArr = Array<PacketArr | number>;

interface PacketPair {
  first: PacketArr;
  second: PacketArr;
}

export { PacketArr, PacketPair };
