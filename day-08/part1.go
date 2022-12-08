package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	input := [][]byte{}

	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		input = append(input, []byte(text[:len(text)-1]))
	}

	total := 0
	total += countPerimeter(input)
	total += visibleRows(input)

	fmt.Println(total)
}

func countPerimeter(trees [][]byte) int {
	return len(trees)*2 + (len(trees[0])-2)*2
}

func visibleRows(trees [][]byte) int {
	marked := make([][]byte, len(trees))

	for i := 0; i < len(trees); i++ {
		marked[i] = make([]byte, len(trees[i]))
	}

	for i := 1; i < len(trees)-1; i++ {
		maxHeight := trees[i][0]

		// count from left
		for j := 1; j < len(trees[i])-1; j++ {
			tree := trees[i][j]
			if tree > maxHeight {
				maxHeight = tree
				marked[i][j] = 1
			}
		}

		// count from right
		maxHeight = trees[i][len(trees[i])-1]
		for j := len(trees[i]) - 1; j > 0; j-- {
			tree := trees[i][j]
			if tree > maxHeight {
				maxHeight = tree
				marked[i][j] = 1
			}
		}
	}

	for j := 1; j < len(trees[0])-1; j++ {

		// count from top
		maxHeight := trees[0][j]
		for i := 1; i < len(trees)-1; i++ {
			tree := trees[i][j]
			if tree > maxHeight {
				maxHeight = tree
				marked[i][j] = 1
			}
		}

		// count from bottom
		maxHeight = trees[len(trees)-1][j]
		for i := len(trees) - 1; i > 0; i-- {
			tree := trees[i][j]
			if tree > maxHeight {
				maxHeight = tree
				marked[i][j] = 1
			}
		}
	}

	total := 0

	for _, row := range marked {
		for _, mark := range row {
			total += int(mark)
		}
	}
	return total
}
