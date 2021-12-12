import aoclib

var data = lines(file: "input.txt").map { $0.map { Int(String($0))! } }

var flashes = 0

for t in 0..<300 {
  for (p, _) in data.asGrid() {
    data[p] += 1
  }
  var flashed = true
  var reset = Set<Pt2>()
  while flashed {
    flashed = false
    for (p, v) in data.asGrid() {
      if v > 9 {
        flashes += 1
        flashed = true
        reset.insert(p)
        for n in p.neighbors(data) {
          data[n] += 1
        }
        data[p] = -10
      }
    }
  }
  if reset.count == 100 {
    print(t)
  }
  for p in reset {
    data[p] = 0
  }
  
//  for l in data {
//    print("".join(l.map { String($0) }))
//  }
//  print()
}

print(flashes)