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

	fmt.Println(maxScenicScore(input))
}

func maxScenicScore(trees [][]byte) int {
	maxScore := 0

	for i := 0; i < len(trees); i++ {
		for j := 0; j < len(trees[0]); j++ {
			score := calcScenicScore(trees, i, j)
			if score > maxScore {
				maxScore = score
			}
		}
	}
	return maxScore
}

func calcScenicScore(trees [][]byte, a, b int) int {
	score := 1

	count := 0
	for i := a + 1; i < len(trees); i++ {
		count += 1
		if trees[a][b] <= trees[i][b] {
			break
		}
	}
	score *= count

	count = 0
	for i := a - 1; i >= 0; i-- {
		count += 1
		if trees[a][b] <= trees[i][b] {
			break
		}
	}
	score *= count

	count = 0
	for j := b + 1; j < len(trees[a]); j++ {
		count += 1
		if trees[a][b] <= trees[a][j] {
			break
		}
	}
	score *= count

	count = 0
	for j := b - 1; j >= 0; j-- {
		count += 1
		if trees[a][b] <= trees[a][j] {
			break
		}
	}
	score *= count

	return score
}
