package main

import (
	"testing"

	"github.com/dawidl022/advent-of-code-2022/day-22/logic"
	"github.com/stretchr/testify/assert"
)

func TestWrapAroundCube(t *testing.T) {
	type test struct {
		inputPoint     logic.Upoint
		inputDirection logic.Point
		expected       logic.Bearing
	}
	board := logic.Board{}

	tests := []test{
		{logic.Upoint{51, 1, determineFace(51, 1)}, logic.Up, logic.Bearing{
			logic.Upoint{1, 151, 6}, logic.Right,
		}},
		{logic.Upoint{100, 1, determineFace(100, 1)}, logic.Up, logic.Bearing{
			logic.Upoint{1, 200, 6}, logic.Right,
		}},
		{logic.Upoint{51, 1, determineFace(51, 1)}, logic.Left, logic.Bearing{
			logic.Upoint{1, 150, 4}, logic.Right,
		}},
		{logic.Upoint{51, 50, determineFace(51, 50)}, logic.Left, logic.Bearing{
			logic.Upoint{1, 101, 4}, logic.Right,
		}},
		{logic.Upoint{101, 1, determineFace(101, 1)}, logic.Up, logic.Bearing{
			logic.Upoint{1, 200, 6}, logic.Up,
		}},
		{logic.Upoint{150, 1, determineFace(150, 1)}, logic.Up, logic.Bearing{
			logic.Upoint{50, 200, 6}, logic.Up,
		}},
		{logic.Upoint{150, 1, determineFace(150, 1)}, logic.Right, logic.Bearing{
			logic.Upoint{100, 150, 5}, logic.Left,
		}},
		{logic.Upoint{150, 50, determineFace(150, 50)}, logic.Right, logic.Bearing{
			logic.Upoint{100, 101, 5}, logic.Left,
		}},
		{logic.Upoint{101, 50, determineFace(101, 50)}, logic.Down, logic.Bearing{
			logic.Upoint{100, 51, 3}, logic.Left,
		}},
		{logic.Upoint{150, 50, determineFace(150, 50)}, logic.Down, logic.Bearing{
			logic.Upoint{100, 100, 3}, logic.Left,
		}},
		{logic.Upoint{51, 51, determineFace(51, 51)}, logic.Left, logic.Bearing{
			logic.Upoint{1, 101, 4}, logic.Down,
		}},
		{logic.Upoint{51, 100, determineFace(51, 100)}, logic.Left, logic.Bearing{
			logic.Upoint{50, 101, 4}, logic.Down,
		}},
		{logic.Upoint{100, 51, determineFace(100, 51)}, logic.Right, logic.Bearing{
			logic.Upoint{101, 50, 2}, logic.Up,
		}},
		{logic.Upoint{100, 100, determineFace(100, 100)}, logic.Right, logic.Bearing{
			logic.Upoint{150, 50, 2}, logic.Up,
		}},
		{logic.Upoint{100, 101, determineFace(100, 101)}, logic.Right, logic.Bearing{
			logic.Upoint{150, 50, 2}, logic.Left,
		}},
		{logic.Upoint{100, 150, determineFace(100, 150)}, logic.Right, logic.Bearing{
			logic.Upoint{150, 1, 2}, logic.Left,
		}},
		{logic.Upoint{51, 150, determineFace(51, 150)}, logic.Down, logic.Bearing{
			logic.Upoint{50, 151, 6}, logic.Left,
		}},
		{logic.Upoint{100, 150, determineFace(100, 150)}, logic.Down, logic.Bearing{
			logic.Upoint{50, 200, 6}, logic.Left,
		}},
		{logic.Upoint{1, 101, determineFace(1, 101)}, logic.Up, logic.Bearing{
			logic.Upoint{51, 51, 3}, logic.Right,
		}},
		{logic.Upoint{50, 101, determineFace(50, 101)}, logic.Up, logic.Bearing{
			logic.Upoint{51, 100, 3}, logic.Right,
		}},
		{logic.Upoint{1, 101, determineFace(1, 101)}, logic.Left, logic.Bearing{
			logic.Upoint{51, 50, 1}, logic.Right,
		}},
		{logic.Upoint{1, 150, determineFace(1, 150)}, logic.Left, logic.Bearing{
			logic.Upoint{51, 1, 1}, logic.Right,
		}},
		{logic.Upoint{50, 151, determineFace(50, 151)}, logic.Right, logic.Bearing{
			logic.Upoint{51, 150, 5}, logic.Up,
		}},
		{logic.Upoint{50, 200, determineFace(50, 200)}, logic.Right, logic.Bearing{
			logic.Upoint{100, 150, 5}, logic.Up,
		}},
		{logic.Upoint{1, 151, determineFace(1, 151)}, logic.Left, logic.Bearing{
			logic.Upoint{51, 1, 1}, logic.Down,
		}},
		{logic.Upoint{1, 200, determineFace(1, 200)}, logic.Left, logic.Bearing{
			logic.Upoint{100, 1, 1}, logic.Down,
		}},
		{logic.Upoint{1, 200, determineFace(1, 200)}, logic.Down, logic.Bearing{
			logic.Upoint{101, 1, 2}, logic.Down,
		}},
		{logic.Upoint{50, 200, determineFace(50, 200)}, logic.Down, logic.Bearing{
			logic.Upoint{150, 1, 2}, logic.Down,
		}},
	}

	for _, tc := range tests {
		actual := wrapAroundCube(tc.inputPoint, tc.inputDirection, board)
		assert.Equal(t, tc.expected, actual)
	}
}
