package main

import (
	"math"

	"github.com/dawidl022/advent-of-code-2022/day-22/logic"
)

func main() {
	logic.FindPassword(wrapToOtherSide, singleFace)
}

func wrapToOtherSide(p logic.Upoint, direction logic.Point, board logic.Board) logic.Bearing {
	switch direction {
	case logic.Point{X: 1, Y: 0}:
		p = logic.Upoint{X: 0, Y: p.Y, Face: 1}
		for {
			if _, isOpenTile := board.OpenTiles[p]; isOpenTile {
				break
			}
			if _, isWall := board.Walls[p]; isWall {
				break
			}
			p = logic.Upoint{X: p.X + 1, Y: p.Y, Face: 1}
		}
	case logic.Point{X: 0, Y: 1}:
		p = logic.Upoint{X: p.X, Y: 0, Face: 1}
		for {
			if _, isOpenTile := board.OpenTiles[p]; isOpenTile {
				break
			}
			if _, isWall := board.Walls[p]; isWall {
				break
			}
			p = logic.Upoint{X: p.X, Y: p.Y + 1, Face: 1}
		}
	case logic.Point{X: -1, Y: 0}:
		p = logic.Upoint{X: math.MaxUint8, Y: p.Y, Face: 1}
		for {
			if _, isOpenTile := board.OpenTiles[p]; isOpenTile {
				break
			}
			if _, isWall := board.Walls[p]; isWall {
				break
			}
			p = logic.Upoint{X: p.X - 1, Y: p.Y, Face: 1}
		}
	case logic.Point{X: 0, Y: -1}:
		p = logic.Upoint{X: p.X, Y: math.MaxUint8, Face: 1}
		for {
			if _, isOpenTile := board.OpenTiles[p]; isOpenTile {
				break
			}
			if _, isWall := board.Walls[p]; isWall {
				break
			}
			p = logic.Upoint{X: p.X, Y: p.Y - 1, Face: 1}
		}
	default:
		panic("unexpected direction")
	}
	return logic.Bearing{Position: p, Direction: direction}
}

// in part1 everything is flat so the face is always 1
func singleFace(x uint8, y uint8) uint8 {
	return 1
}
