class FileNumber {
    var number: Int
    var position: Int

    init(number: Int, position: Int) {
        self.number = number
        self.position = position
    }
}

func arrangeByPosition(_ arr: [FileNumber]) -> [FileNumber] {
    var res: [FileNumber] = Array(repeating: FileNumber(number: 0, position: 0), count: arr.count)

    for file in arr {
        res[file.position] = file
    }
    return res
}

func mix(_ numsByMixOrder: [FileNumber], numsByPosition: inout [FileNumber]) {
    for fileNum in numsByMixOrder {
            let max_iter = fileNum.number % (numsByMixOrder.count - 1)
            if fileNum.number > 0 {
                for _ in 0..<max_iter {
                    let partnerPos = fileNum.position + 1 < numsByMixOrder.count ? fileNum.position + 1 : 0
                    let partner = numsByPosition[partnerPos]

                    numsByPosition.swapAt(fileNum.position, partner.position)
                    partner.position = fileNum.position
                    fileNum.position = partnerPos
                }
            }
            if fileNum.number < 0 {
                for _ in max_iter..<0 {
                    let partnerPos = fileNum.position > 0 ? fileNum.position - 1 : numsByMixOrder.count - 1
                    let partner = numsByPosition[partnerPos]

                    numsByPosition.swapAt(fileNum.position, partner.position)
                    partner.position = fileNum.position
                    fileNum.position = partnerPos
                }
            }
        }
}

func getGroveCoords(_ numsByPosition: [FileNumber]) -> Int {
    var i = 0
    while numsByPosition[i].number != 0  {
        i += 1
    }
    var sum = 0
    for j in [1000, 2000, 3000] {
        sum += numsByPosition[(i + j) % numsByPosition.count].number
    }
    return sum
}

func parseInput() -> [FileNumber] {
    var res: [FileNumber] = []
    var line = readLine()
    var i = 0
    while line != nil {
        res.append(FileNumber(number: Int(line!)!, position: i))
        i += 1
        line = readLine()
    }
    return res
}
