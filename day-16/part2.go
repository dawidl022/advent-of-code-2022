package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type valve struct {
	name     string
	flowRate int
	leadsTo  []string
	setBit   int16
}

type memoEntry struct {
	valveMe         *valve
	valveElephant   *valve
	timeRemaining   int8
	remainingValves int16
}

func parseInput() (map[string]*valve, int16) {
	valves := make(map[string]*valve)
	regex := regexp.MustCompile("Valve ([A-Z][A-Z]) has flow rate=([0-9]+); tunnel[s]? lead[s]? to valve[s]? (.*)")

	reader := bufio.NewReader(os.Stdin)
	var setBit int16 = 1

	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		res := regex.FindStringSubmatch(text)
		flowRate, _ := strconv.Atoi(res[2])
		valves[res[1]] = &valve{
			name:     res[1],
			flowRate: flowRate,
			leadsTo:  strings.Split(res[3], ", "),
		}
		if flowRate > 0 {
			valves[res[1]].setBit = setBit
			setBit <<= 1
		}
	}

	return valves, setBit - 1
}

func maxValvePressure(valves map[string]*valve, currentValveMe *valve,
	currentValveElephant *valve, currentPressure int, remainingValves int16, timeRemaining int8, memo map[memoEntry]int) int {

	memoEn := memoEntry{
		valveMe:         currentValveMe,
		valveElephant:   currentValveElephant,
		timeRemaining:   timeRemaining,
		remainingValves: remainingValves,
	}
	if result, memoized := memo[memoEn]; memoized {
		return result
	}
	if result, memoized := memo[memoEntry{valveMe: currentValveElephant, valveElephant: currentValveMe, timeRemaining: timeRemaining, remainingValves: remainingValves}]; memoized {
		return result
	}
	if timeRemaining <= 1 || remainingValves == 0 {
		result := currentPressure * int(timeRemaining)
		memo[memoEn] = result
		return result
	}
	newRemainingMeValves := remainingValves & ^currentValveMe.setBit
	newRemainingElephantValves :=
		remainingValves & ^currentValveElephant.setBit
	newRemainingBothValves :=
		remainingValves & ^currentValveMe.setBit & ^currentValveElephant.setBit

	meCanSkip := currentValveMe.flowRate == 0 ||
		remainingValves&currentValveMe.setBit == 0
	elephantCanSkip := currentValveElephant.flowRate == 0 ||
		remainingValves&currentValveElephant.setBit == 0

	if meCanSkip && elephantCanSkip {
		candidatesWithout := make([]int, 0, len(currentValveMe.leadsTo)+len(currentValveElephant.leadsTo))
		for _, meLeadsTo := range currentValveMe.leadsTo {
			for _, elephantLeadsTo := range currentValveElephant.leadsTo {
				candidatesWithout = append(candidatesWithout, maxValvePressure(
					valves, valves[meLeadsTo], valves[elephantLeadsTo],
					currentPressure, newRemainingBothValves, timeRemaining-1, memo,
				))
			}
		}
		result := currentPressure + max(candidatesWithout...)
		memo[memoEn] = result
		return result
	}

	if elephantCanSkip {
		candidatesWithout := make([]int, 0, len(currentValveMe.leadsTo)+len(currentValveElephant.leadsTo))
		for _, meLeadsTo := range currentValveMe.leadsTo {
			for _, elephantLeadsTo := range currentValveElephant.leadsTo {
				candidatesWithout = append(candidatesWithout, maxValvePressure(
					valves, valves[meLeadsTo], valves[elephantLeadsTo],
					currentPressure, newRemainingElephantValves, timeRemaining-1, memo,
				))
			}
		}
		maxPressureWithout := max(candidatesWithout...)

		candidatesWith := make([]int, 0, len(currentValveElephant.leadsTo))
		for _, elephantLeadsTo := range currentValveElephant.leadsTo {
			candidatesWith = append(candidatesWith, maxValvePressure(
				valves,
				currentValveMe,
				valves[elephantLeadsTo],
				currentPressure+currentValveMe.flowRate,
				newRemainingBothValves,
				timeRemaining-1,
				memo,
			))
		}
		maxPressureWith := max(candidatesWith...)

		result := currentPressure + max(maxPressureWithout, maxPressureWith)
		memo[memoEn] = result
		return result
	}
	if meCanSkip {
		candidatesWithout := make([]int, 0, len(currentValveMe.leadsTo)+len(currentValveElephant.leadsTo))
		for _, meLeadsTo := range currentValveMe.leadsTo {
			for _, elephantLeadsTo := range currentValveElephant.leadsTo {
				candidatesWithout = append(candidatesWithout, maxValvePressure(
					valves, valves[meLeadsTo], valves[elephantLeadsTo],
					currentPressure, newRemainingMeValves, timeRemaining-1, memo,
				))
			}
		}
		maxPressureWithout := max(candidatesWithout...)

		candidatesWith := make([]int, 0, len(currentValveMe.leadsTo))
		for _, meLeadsTo := range currentValveMe.leadsTo {
			candidatesWith = append(candidatesWith, maxValvePressure(
				valves, valves[meLeadsTo], currentValveElephant,
				currentPressure+currentValveElephant.flowRate, newRemainingBothValves,
				timeRemaining-1, memo,
			))
		}
		maxPressureWith := max(candidatesWith...)

		result := currentPressure + max(maxPressureWithout, maxPressureWith)
		memo[memoEn] = result
		return result
	}
	candidatesWithout := make([]int, 0, len(currentValveMe.leadsTo)+len(currentValveElephant.leadsTo))
	for _, meLeadsTo := range currentValveMe.leadsTo {
		for _, elephantLeadsTo := range currentValveElephant.leadsTo {
			candidatesWithout = append(candidatesWithout, maxValvePressure(
				valves, valves[meLeadsTo], valves[elephantLeadsTo],
				currentPressure, remainingValves, timeRemaining-1, memo,
			))
		}
	}
	maxPressureWithout := max(candidatesWithout...)

	candidatesWithElephant := make([]int, 0, len(currentValveMe.leadsTo))
	for _, meLeadsTo := range currentValveMe.leadsTo {
		candidatesWithElephant = append(candidatesWithElephant, maxValvePressure(
			valves, valves[meLeadsTo], currentValveElephant,
			currentPressure+currentValveElephant.flowRate, newRemainingElephantValves,
			timeRemaining-1, memo,
		))
	}
	maxPressureWithElepahnt := max(candidatesWithElephant...)

	candidatesWithMe := make([]int, 0, len(currentValveElephant.leadsTo))
	for _, elephantLeadsTo := range currentValveElephant.leadsTo {
		candidatesWithMe = append(candidatesWithMe, maxValvePressure(
			valves,
			currentValveMe,
			valves[elephantLeadsTo],
			currentPressure+currentValveMe.flowRate,
			newRemainingMeValves,
			timeRemaining-1,
			memo,
		))
	}
	maxPressureWithMe := max(candidatesWithMe...)

	maxPressureWithBoth := 0
	if currentValveMe != currentValveElephant {
		candidatesWithBoth := make([]int, len(currentValveMe.leadsTo)+len(currentValveElephant.leadsTo))
		for _, meLeadsTo := range currentValveMe.leadsTo {
			for _, elephantLeadsTo := range currentValveElephant.leadsTo {
				candidatesWithBoth = append(candidatesWithBoth, maxValvePressure(
					valves,
					valves[meLeadsTo],
					valves[elephantLeadsTo],
					currentPressure+currentValveMe.flowRate+currentValveElephant.flowRate,
					newRemainingBothValves,
					timeRemaining-2,
					memo,
				))
			}
		}
		maxPressureWithBoth = currentPressure + currentValveMe.flowRate + currentValveElephant.flowRate + max(candidatesWithBoth...)
	}
	result := currentPressure + max(maxPressureWithout, maxPressureWithMe, maxPressureWithElepahnt, maxPressureWithBoth)
	memo[memoEn] = result
	return result
}

func max(nums ...int) int {
	highest := nums[0]
	for i := 1; i < len(nums); i++ {
		if nums[i] > highest {
			highest = nums[i]
		}
	}
	return highest
}

func main() {
	valves, remainingValves := parseInput()
	fmt.Println(maxValvePressure(valves, valves["AA"], valves["AA"], 0, remainingValves, 26, make(map[memoEntry]int)))
}
