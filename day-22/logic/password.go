package logic

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var (
	Up    = Point{0, -1}
	Right = Point{1, 0}
	Down  = Point{0, 1}
	Left  = Point{-1, 0}
)

type wrapStrategy func(Upoint, Point, Board) Bearing

type faceDeterminer func(uint8, uint8) uint8

type Upoint struct {
	X    uint8
	Y    uint8
	Face uint8
}

type Point struct {
	X int8
	Y int8
}

type Bearing struct {
	Position  Upoint
	Direction Point
}

type Board struct {
	OpenTiles map[Upoint]struct{}
	Walls     map[Upoint]struct{}
}

type instruction interface {
	execute(Bearing, Board, wrapStrategy, faceDeterminer) Bearing
}

type moveInstruction struct {
	magnitude int
}

type rotateInstruction struct {
	clockwise bool
}

func (m moveInstruction) execute(p Bearing, b Board, wrapToOtherSide wrapStrategy,
	determineFace faceDeterminer) Bearing {

	currPosition := p.Position
	currDirection := p.Direction
	for i := 0; i < m.magnitude; i++ {
		newPosition := Upoint{
			uint8(int16(currPosition.X) + int16(currDirection.X)),
			uint8(int16(currPosition.Y) + int16(currDirection.Y)),
			0,
		}
		newPosition.Face = determineFace(newPosition.X, newPosition.Y)

		if _, isOpenTile := b.OpenTiles[newPosition]; isOpenTile {
			currPosition = newPosition
		} else if _, isWall := b.Walls[newPosition]; isWall {
			break
		} else {
			newBearing := wrapToOtherSide(currPosition, currDirection, b)
			newPosition = newBearing.Position
			newDirection := newBearing.Direction

			if _, isOpenTile := b.OpenTiles[newPosition]; isOpenTile {
				currPosition = newPosition
				currDirection = newDirection
			} else if _, isWall := b.Walls[newPosition]; isWall {
				break
			}
		}
	}
	return Bearing{currPosition, currDirection}
}

func (r rotateInstruction) execute(p Bearing, _ Board, _ wrapStrategy, _ faceDeterminer) Bearing {
	var newDirection Point

	switch p.Direction {
	case Point{1, 0}:
		newDirection = Point{0, 1}
	case Point{0, 1}:
		newDirection = Point{-1, 0}
	case Point{-1, 0}:
		newDirection = Point{0, -1}
	case Point{0, -1}:
		newDirection = Point{1, 0}
	default:
		panic("unexpected direction")
	}

	if !r.clockwise {
		newDirection = Point{newDirection.X * -1, newDirection.Y * -1}
	}
	return Bearing{p.Position, newDirection}
}

func FindPassword(strategy wrapStrategy, determineFace func(uint8, uint8) uint8) {
	instruction, board := parseInput(determineFace)
	currBearing := Bearing{Position: initialPosition(board), Direction: Point{1, 0}}

	for _, inst := range instruction {
		currBearing = inst.execute(currBearing, board, strategy, determineFace)
	}
	result := 1000*int(currBearing.Position.Y) + int(currBearing.Position.X)*4 + directionValue(currBearing.Direction)
	fmt.Println(result)
}

func directionValue(direction Point) int {
	switch direction {
	case Point{1, 0}:
		return 0
	case Point{0, 1}:
		return 1
	case Point{-1, 0}:
		return 2
	case Point{0, -1}:
		return 3
	default:
		panic("unexpected direction")
	}
}

func initialPosition(board Board) Upoint {
	currPosition := Upoint{1, 1, 1}
	for {
		if _, isOpenTile := board.OpenTiles[currPosition]; isOpenTile {
			break
		}
		currPosition = Upoint{currPosition.X + 1, currPosition.Y, currPosition.Face}
	}
	return currPosition
}

func parseInput(determineFace faceDeterminer) ([]instruction, Board) {
	reader := bufio.NewReader(os.Stdin)
	openTiles := make(map[Upoint]struct{})
	walls := make(map[Upoint]struct{})

	var y byte = 1

	for {
		text, _ := reader.ReadString('\n')
		if text == "\n" {
			break
		}
		for i, char := range text {
			p := Upoint{byte(i + 1), y, determineFace(byte(i+1), y)}
			if char == '.' {
				openTiles[p] = struct{}{}
			} else if char == '#' {
				walls[p] = struct{}{}
			}
		}
		y++
	}
	b := Board{OpenTiles: openTiles, Walls: walls}

	raw_instructions, _ := reader.ReadString('\n')
	return parseInstructions(strings.Trim(raw_instructions, "\n")), b
}

func parseInstructions(raw string) []instruction {
	instructions := []instruction{}
	mag := 0
	for _, ch := range raw {
		if (ch == 'L' || ch == 'R') && mag > 0 {
			instructions = append(instructions, moveInstruction{magnitude: mag})
			mag = 0
		}
		if ch == 'L' {
			instructions = append(instructions, rotateInstruction{clockwise: false})
		} else if ch == 'R' {
			instructions = append(instructions, rotateInstruction{clockwise: true})
		} else {
			mag = mag*10 + int(ch) - '0'
		}
	}
	if mag > 0 {
		instructions = append(instructions, moveInstruction{magnitude: mag})
	}
	return instructions
}
