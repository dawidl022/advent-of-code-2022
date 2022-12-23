func main() {
    let arrangement = parseInput()
    var arr = arrangeByPosition(arrangement)

    for file in arrangement {
        file.number *= 811589153
    }

    for _ in 0..<10 {
        mix(arrangement, numsByPosition: &arr)
    }

    print(getGroveCoords(arr))
}

main()
