import aoclib

var data = try! String(contentsOfFile: "input.txt").split(separator: "\n")

let enhancement = data[0]

var grid = data[1...].map { "...." + $0 + "...." }
let blank = String(repeating: ".", count: grid[0].count)
grid.insert(blank, at: 0)
grid.insert(blank, at: 0)
grid.insert(blank, at: 0)
grid.insert(blank, at: 0)
grid.append(blank)
grid.append(blank)
grid.append(blank)
grid.append(blank)
print(grid.count, grid[0].count)

  for l in grid {
    print(l)
  }
  print()


for t in 0..<50 {
  var newGrid = [String]()
  for y in -4..<(grid.count + 4) {
    var newLine = ""
    for x in -4..<(grid[0].count + 4) {
      var num = 0
      for ny in (y-1)...(y+1) {
        for nx in (x-1)...(x+1) {
          num *= 2
          if ny >= 0 && ny < grid.count &&
             nx >= 0 && nx < grid[ny].count {
            if grid[ny][nx] == "#" {
              num += 1
            }
          } else if t % 2 == 1 {
            num += 1
          }
        }
      }
      newLine.append(enhancement[num])
    }
    newGrid.append(newLine)
  }
//  let blank = String(repeating: ".", count: newGrid[0].count)
//  newGrid.insert(blank, at: 0)
//  newGrid.insert(blank, at: 0)
//  newGrid.insert(blank, at: 0)
//  newGrid.insert(blank, at: 0)
//  newGrid.append(blank)
//  newGrid.append(blank)
//  newGrid.append(blank)
//  newGrid.append(blank)
  grid = newGrid
  
//  for l in grid {
//    print(l)
//  }
//  print()
  print(t)
}

var out = 0
for y in 0..<grid.count {
  for x in 0..<grid[y].count {
    if grid[y][x] == "#" {
      out += 1
    }
  }
}
print(out)