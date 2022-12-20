import 'dart:math';
import 'dart:io';

class Valve {
  final String name;
  final int flowRate;
  final List<String> leadsTo;

  Valve(this.name, this.flowRate, this.leadsTo);

  @override
  String toString() {
    return "Valve(${name}, ${flowRate}, ${leadsTo})";
  }
}

class MemoEntry {
  final Valve currentValve;
  final int timeRemaining;
  final int currentPressure;

  MemoEntry(this.currentValve, this.timeRemaining, this.currentPressure);

  @override
  String toString() {
    return "MemoEntry(${currentValve}, ${timeRemaining}";
  }

  @override
  bool operator ==(Object other) {
    if (!(other is MemoEntry)) {
      return false;
    }
    return this.currentValve == other.currentValve &&
        this.timeRemaining == other.timeRemaining &&
        this.currentPressure == other.currentPressure;
  }

  @override
  int get hashCode {
    return Object.hash(
        this.currentValve, this.timeRemaining, this.currentPressure);
  }
}

Map<String, Valve> parseInput() {
  Map<String, Valve> valves = Map();
  RegExp regex = RegExp(
      "Valve ([A-Z][A-Z]) has flow rate=([0-9]+); tunnel[s]? lead[s]? to valve[s]? (.*)");

  while (true) {
    String? line = stdin.readLineSync();
    if (line == null) {
      break;
    }
    final match = regex.firstMatch(line.trim());
    valves[match!.group(1)!] = Valve(match.group(1)!,
        int.parse(match.group(2)!), match.group(3)!.split(', '));
  }

  return valves;
}

int maxValvePressure(
    Map<String, Valve> valves,
    Valve currentValve,
    int currentPressure,
    Set<String> remainingValves,
    int timeRemaining,
    Map<MemoEntry, int> memo) {
  final memoEntry = MemoEntry(currentValve, timeRemaining, currentPressure);
  final memoized = memo[memoEntry];
  if (memoized != null) {
    return memoized;
  }
  if (timeRemaining <= 1 || remainingValves.isEmpty) {
    final result = currentPressure * timeRemaining;
    memo[memoEntry] = result;
    return result;
  }
  final newRemainingValves = remainingValves.difference({currentValve.name});
  if (currentValve.flowRate == 0 ||
      !remainingValves.contains(currentValve.name)) {
    final candidates = currentValve.leadsTo.map((valveName) => maxValvePressure(
        valves,
        valves[valveName]!,
        currentPressure,
        newRemainingValves,
        timeRemaining - 1,
        memo));
    final maxPressure = currentPressure + candidates.reduce(max);

    memo[memoEntry] = maxPressure;
    return maxPressure;
  }
  final candidatesWithout = currentValve.leadsTo.map((valveName) =>
      maxValvePressure(valves, valves[valveName]!, currentPressure,
          remainingValves, timeRemaining - 1, memo));

  final candidatesWith = currentValve.leadsTo.map((valveName) =>
      maxValvePressure(
          valves,
          valves[valveName]!,
          currentPressure + currentValve.flowRate,
          newRemainingValves,
          timeRemaining - 2,
          memo));
  final maxWithoutPressure = currentPressure + candidatesWithout.reduce(max);
  final maxWithPressure = currentValve.flowRate +
      currentPressure +
      currentPressure +
      candidatesWith.reduce(max);

  final result = max(maxWithPressure, maxWithoutPressure);
  memo[memoEntry] = result;
  return result;
}

void main() {
  final valves = parseInput();
  print(
      maxValvePressure(valves, valves["AA"]!, 0, valves.keys.toSet(), 30, {}));
}
