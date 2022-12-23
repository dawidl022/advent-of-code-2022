func main() {
    let arrangement = parseInput()
    var arr = arrangeByPosition(arrangement)

    mix(arrangement, numsByPosition: &arr)

    print(getGroveCoords(arr))
}

main()
