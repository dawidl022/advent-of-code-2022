package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	total := 0

	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		total += snafuToDec(strings.Trim(line, "\n"))
	}

	fmt.Println(decToSnafu(total))
}

func snafuToDec(snafu string) int {
	number := 0
	for _, char := range snafu {
		number *= 5
		if char == '=' {
			number -= 2
		} else if char == '-' {
			number -= 1
		} else {
			number += int(char) - '0'
		}
	}
	return number
}

func decToSnafu(dec int) string {
	result := []byte{}
	carry := 0

	for dec > 0 {
		base5Digit := dec%5 + carry
		if base5Digit == 3 {
			base5Digit = '='
			carry = 1
		} else if base5Digit == 4 {
			base5Digit = '-'
			carry = 1
		} else if base5Digit == 5 {
			base5Digit = '0'
		} else {
			base5Digit += '0'
			carry = 0
		}
		result = append(result, byte(base5Digit))
		dec /= 5
	}
	reverse(result)
	return string(result)
}

func reverse[T any](slice []T) {
	for i := 0; i < len(slice)/2; i++ {
		tmp := slice[i]
		slice[i] = slice[len(slice)-i-1]
		slice[len(slice)-i-1] = tmp
	}
}
