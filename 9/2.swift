import aoclib

var data = lines()

func neighbors(_ pos: [Int]) -> [[Int]] {
  var output = [[Int]]()
  for dy in [-1, 1] {
    let y = pos[1] + dy
    if y >= 0 && y < data.count {
      output.append([pos[0], y])
    }
  }
  for dx in [-1, 1] {
    let x = pos[0] + dx
    if x >= 0 && x < data[0].count {
      output.append([x, pos[1]])
    }
  }
  return output
}

var lows = [[Int]]()
for x in 0..<data[0].count {
  loop: for y in 0..<data.count {
    for n in neighbors([x, y]) {
      if Int(String(data[y][x]))! >= Int(String(data[n[1]][n[0]]))! {
        continue loop
      }
    }
    lows.append([x, y])
  }
}

var basins = [Set<[Int]>]()
for p in lows {
  let q = Queue<[Int]>()
  q.push(p)
  var basin = Set<[Int]>()
  while let cur = q.pop() {
    for n in neighbors(cur) {
      if data[n[1]][n[0]] != Character("9") && !basin.contains(n) {
        q.push(n)
        basin.insert(n)
      }
    }
  }
  basins.append(basin)
}

//print(basins)
basins.sort {
  $0.count > $1.count
}
print(basins.map { $0.count })
var output = 0
print(basins[0].count * basins[1].count * basins[2].count)
