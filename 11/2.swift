import aoclib

var data = lines(file: "input.txt").map { $0.map { Int(String($0))! } }

func neighbors(_ p: [Int]) -> [[Int]] {
  var out = [[Int]]()
  for dx in -1...1 {
    for dy in -1...1 {
      let newp = [p[0] + dx, p[1] + dy]
      if newp[0] >= 0 && newp[0] < data.count &&
         newp[1] >= 0 && newp[1] < data.count &&
         newp != p {
        out.append(newp)
      }
    }
  }
  return out
}

var flashes = 0

for t in 0..<100000 {
  for x in 0..<10 {
    for y in 0..<10 {
      data[y][x] += 1
    }
  }
  var flashed = true
  var reset = Set<[Int]>()
  while flashed {
    flashed = false
    for x in 0..<10 {
      for y in 0..<10 {
        if data[y][x] > 9 {
          flashes += 1
          flashed = true
          reset.insert([x, y])
          for n in neighbors([x, y]) {
            data[n[1]][n[0]] += 1
          }
          data[y][x] = -10
        }
      }
    }
  }
  if reset.count == 100 {
    print(t)
  }
  for p in reset {
    data[p[1]][p[0]] = 0
  }
  
//  for l in data {
//    print("".join(l.map { String($0) }))
//  }
//  print()
}

print(flashes)