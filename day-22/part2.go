package main

import (
	"github.com/dawidl022/advent-of-code-2022/day-22/logic"
)

func main() {
	logic.FindPassword(wrapAroundCube, determineFace)
}

// hard coded to work for the cube provided as input
func wrapAroundCube(p logic.Upoint, direction logic.Point, _ logic.Board) logic.Bearing {
	switch p.Face {
	case 1:
		switch direction {
		case logic.Up:
			direction = logic.Right
			p = logic.Upoint{1, 100 + p.X, 6}
		case logic.Left:
			direction = logic.Right
			p = logic.Upoint{1, 151 - p.Y, 4}
		default:
			panic("unsupported wrapping direction for face 1")
		}
	case 2:
		switch direction {
		case logic.Up:
			p = logic.Upoint{p.X - 100, 200, 6}
		case logic.Right:
			direction = logic.Left
			p = logic.Upoint{100, 151 - p.Y, 5}
		case logic.Down:
			direction = logic.Left
			p = logic.Upoint{100, p.X - 50, 3}
		default:
			panic("unsupported wrapping direction for face 2")
		}
	case 3:
		switch direction {
		case logic.Left:
			direction = logic.Down
			p = logic.Upoint{p.Y - 50, 101, 4}
		case logic.Right:
			direction = logic.Up
			p = logic.Upoint{50 + p.Y, 50, 2}
		default:
			panic("unsupported wrapping direction for face 3")
		}
	case 4:
		switch direction {
		case logic.Up:
			direction = logic.Right
			p = logic.Upoint{51, 50 + p.X, 3}
		case logic.Left:
			direction = logic.Right
			p = logic.Upoint{51, 51 - (p.Y - 100), 1}
		default:
			panic("unsupported wrapping direction for face 4")
		}
	case 5:
		switch direction {
		case logic.Right:
			direction = logic.Left
			p = logic.Upoint{150, 51 - (p.Y - 100), 2}
		case logic.Down:
			direction = logic.Left
			p = logic.Upoint{50, p.X + 100, 6}
		default:
			panic("unsupported wrapping direction for face 5")
		}
	case 6:
		switch direction {
		case logic.Right:
			direction = logic.Up
			p = logic.Upoint{p.Y - 100, 150, 5}
		case logic.Left:
			direction = logic.Down
			p = logic.Upoint{p.Y - 100, 1, 1}
		case logic.Down:
			p = logic.Upoint{p.X + 100, 1, 2}
		}
	default:
		panic("unexpected face")
	}
	return logic.Bearing{Position: p, Direction: direction}
}

// hard coded to net from input
func determineFace(x uint8, y uint8) uint8 {
	if y <= 50 {
		if x <= 100 {
			return 1
		}
		return 2
	}
	if y <= 100 {
		return 3
	}
	if y <= 150 {
		if x <= 50 {
			return 4
		}
		return 5
	}
	return 6
}
