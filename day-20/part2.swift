class FileNumber {
    var number: Int
    var position: Int

    init(number: Int, position: Int) {
        self.number = number
        self.position = position
    }
}

func arrange(arr: [FileNumber]) -> [FileNumber] {
    var res: [FileNumber] = Array(repeating: FileNumber(number: 0, position: 0), count: arr.count)

    for file in arr {
        res[file.position] = file
    }
    return res
}

var arrangement: [FileNumber] = []
var line = readLine()
var i = 0
while line != nil {
    arrangement.append(FileNumber(number: Int(line!)!, position: i))
    i += 1
    line = readLine()
}

for file in arrangement {
    file.number *= 811589153
}

var arr = arrange(arr: arrangement)

for _ in 0..<10 {
    for file in arrangement {
        let max_iter = file.number % (arrangement.count - 1)
        if file.number > 0 {
            for _ in 0..<max_iter {
                let partnerPos = file.position + 1 < arrangement.count ? file.position + 1 : 0
                let partner = arr[partnerPos]
                arr.swapAt(file.position, partner.position)
                partner.position = file.position
                file.position = partnerPos
            }
        }
        if file.number < 0 {
            for _ in max_iter..<0 {
                let partnerPos = file.position > 0 ? file.position - 1 : arrangement.count - 1
                let partner = arr[partnerPos]
                arr.swapAt(file.position, partner.position)
                partner.position = file.position
                file.position = partnerPos
            }
        }
    }
}

i = 0
while arr[i].number != 0  {
    i += 1
}
var sum = 0
for j in [1000, 2000, 3000] {
    sum += arr[(i + j) % arr.count].number
}
print(sum)
