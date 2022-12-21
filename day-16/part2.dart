import 'dart:math';
import 'dart:io';

// NOT efficient enough to complete on a machine with 16GB of memory

class Valve {
  final String name;
  final int flowRate;
  final List<String> leadsTo;
  final int setBit;

  Valve(this.name, this.flowRate, this.leadsTo, this.setBit);

  @override
  String toString() {
    return "Valve(${name}, ${flowRate}, ${leadsTo}, ${setBit})";
  }
}

class MemoEntry {
  final Valve currentValveMe;
  final Valve currentValveElephant;
  final int timeRemaining;
  final int remainingValues;

  MemoEntry(this.currentValveMe, this.currentValveElephant, this.timeRemaining,
      this.remainingValues);

  @override
  bool operator ==(Object other) {
    if (!(other is MemoEntry)) {
      return false;
    }
    return (this.currentValveMe == other.currentValveMe &&
                this.currentValveElephant == other.currentValveElephant ||
            this.currentValveMe == other.currentValveElephant &&
                this.currentValveElephant == other.currentValveMe) &&
        this.timeRemaining == other.timeRemaining &&
        this.remainingValues == other.remainingValues;
  }

  @override
  int get hashCode {
    return Object.hash(this.currentValveMe, this.currentValveElephant,
        this.timeRemaining, this.remainingValues);
  }
}

class ParseResult {
  Map<String, Valve> valves;
  int remainingValves;

  ParseResult(this.valves, this.remainingValves);
}

ParseResult parseInput() {
  Map<String, Valve> valves = Map();
  RegExp regex = RegExp(
      "Valve ([A-Z][A-Z]) has flow rate=([0-9]+); tunnel[s]? lead[s]? to valve[s]? (.*)");

  int setBit = 1;
  while (true) {
    String? line = stdin.readLineSync();
    if (line == null) {
      break;
    }
    final match = regex.firstMatch(line.trim());
    if (int.parse(match!.group(2)!) > 0) {
      valves[match.group(1)!] = Valve(match.group(1)!,
          int.parse(match.group(2)!), match.group(3)!.split(', '), setBit);
      setBit <<= 1;
    } else {
      valves[match.group(1)!] = Valve(match.group(1)!,
          int.parse(match.group(2)!), match.group(3)!.split(', '), 0);
    }
  }

  return ParseResult(valves, setBit - 1);
}

int maxValvePressure(
    Map<String, Valve> valves,
    Valve currentValveMe,
    Valve currentValveElephant,
    int currentPressure,
    int remainingValves,
    int timeRemaining,
    Map<MemoEntry, int> memo) {
  final memoEntry = MemoEntry(
      currentValveMe, currentValveElephant, timeRemaining, remainingValves);
  final memoized = memo[memoEntry];
  if (memoized != null) {
    return memoized;
  }
  if (timeRemaining <= 1 || remainingValves == 0) {
    final result = currentPressure * timeRemaining;
    memo[memoEntry] = result;
    return result;
  }
  final newRemainingMeValves = remainingValves & ~currentValveMe.setBit;
  final newRemainingElephantValves =
      remainingValves & ~currentValveElephant.setBit;
  final newRemainingBothValves =
      remainingValves & ~currentValveMe.setBit & ~currentValveElephant.setBit;

  final meCanSkip = currentValveMe.flowRate == 0 ||
      remainingValves & currentValveMe.setBit == 0;
  final elephantCanSkip = currentValveElephant.flowRate == 0 ||
      remainingValves & currentValveElephant.setBit == 0;

  if (meCanSkip && elephantCanSkip) {
    final candidatesWithout = [
      for (final meLeadsTo in currentValveMe.leadsTo)
        for (final elephantLeadsTo in currentValveElephant.leadsTo)
          maxValvePressure(valves, valves[meLeadsTo]!, valves[elephantLeadsTo]!,
              currentPressure, newRemainingBothValves, timeRemaining - 1, memo)
    ];
    final result = currentPressure + candidatesWithout.reduce(max);
    memo[memoEntry] = result;
    return result;
  }

  if (elephantCanSkip) {
    final candidatesWithout = [
      for (final meLeadsTo in currentValveMe.leadsTo)
        for (final elephantLeadsTo in currentValveElephant.leadsTo)
          maxValvePressure(
              valves,
              valves[meLeadsTo]!,
              valves[elephantLeadsTo]!,
              currentPressure,
              newRemainingElephantValves,
              timeRemaining - 1,
              memo)
    ];
    final maxPressureWithout = currentPressure + candidatesWithout.reduce(max);

    final candidatesWith = currentValveElephant.leadsTo.map((elephantLeadsTo) =>
        maxValvePressure(
            valves,
            currentValveMe,
            valves[elephantLeadsTo]!,
            currentPressure + currentValveMe.flowRate,
            newRemainingBothValves,
            timeRemaining - 1,
            memo));
    final maxPressureWith = currentPressure + candidatesWith.reduce(max);

    final result = max(maxPressureWith, maxPressureWithout);
    memo[memoEntry] = result;
    return result;
  }
  if (meCanSkip) {
    final candidatesWithout = [
      for (final meLeadsTo in currentValveMe.leadsTo)
        for (final elephantLeadsTo in currentValveElephant.leadsTo)
          maxValvePressure(valves, valves[meLeadsTo]!, valves[elephantLeadsTo]!,
              currentPressure, newRemainingMeValves, timeRemaining - 1, memo)
    ];
    final maxPressureWithout = currentPressure + candidatesWithout.reduce(max);

    final candidatesWith = currentValveMe.leadsTo.map((meLeadsTo) =>
        maxValvePressure(
            valves,
            valves[meLeadsTo]!,
            currentValveElephant,
            currentPressure + currentValveElephant.flowRate,
            newRemainingBothValves,
            timeRemaining - 1,
            memo));
    final maxPressureWith = currentPressure + candidatesWith.reduce(max);

    final result = max(maxPressureWith, maxPressureWithout);
    memo[memoEntry] = result;
    return result;
  }
  final candidatesWithout = [
    for (final meLeadsTo in currentValveMe.leadsTo)
      for (final elephantLeadsTo in currentValveElephant.leadsTo)
        maxValvePressure(valves, valves[meLeadsTo]!, valves[elephantLeadsTo]!,
            currentPressure, remainingValves, timeRemaining - 1, memo)
  ];
  final maxPressureWithout = candidatesWithout.reduce(max);

  final candidatesWithElephant = currentValveMe.leadsTo.map((meLeadsTo) =>
      maxValvePressure(
          valves,
          valves[meLeadsTo]!,
          currentValveElephant,
          currentPressure + currentValveElephant.flowRate,
          newRemainingElephantValves,
          timeRemaining - 1,
          memo));
  final maxPressureWithElephant = candidatesWithElephant.reduce(max);

  final candidatesWithMe = currentValveElephant.leadsTo.map((elephantLeadsTo) =>
      maxValvePressure(
          valves,
          currentValveMe,
          valves[elephantLeadsTo]!,
          currentPressure + currentValveMe.flowRate,
          newRemainingMeValves,
          timeRemaining - 1,
          memo));
  final maxPressureWithMe = candidatesWithMe.reduce(max);

  final candidatesWithBoth = currentValveMe == currentValveElephant
      ? [0]
      : [
          for (final meLeadsTo in currentValveMe.leadsTo)
            for (final elephantLeadsTo in currentValveElephant.leadsTo)
              maxValvePressure(
                  valves,
                  valves[meLeadsTo]!,
                  valves[elephantLeadsTo]!,
                  currentPressure +
                      currentValveMe.flowRate +
                      currentValveElephant.flowRate,
                  newRemainingBothValves,
                  timeRemaining - 2,
                  memo)
        ];

  final maxWithBoth = candidatesWithBoth.reduce(max) +
      currentValveMe.flowRate +
      currentValveElephant.flowRate +
      currentPressure;

  final result = [
        maxPressureWithout,
        maxPressureWithMe,
        maxPressureWithElephant,
        maxWithBoth
      ].reduce(max) +
      currentPressure;
  memo[memoEntry] = result;
  return result;
}

void main() {
  final parseResult = parseInput();
  print(maxValvePressure(parseResult.valves, parseResult.valves["AA"]!,
      parseResult.valves["AA"]!, 0, parseResult.remainingValves, 26, {}));
}
