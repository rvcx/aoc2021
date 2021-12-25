import aoclib

var grid = lines(file: "input.txt").map { [Character]($0) }

for t in 1... {
  let og = grid
  var newG = [[Character]]()
  var newL = [Character]()
  var doNext = false
  for (p, c) in grid.asGrid() {
    if doNext {
      newL.append(">")
      doNext = false
      continue
    }
    if p.y > newG.count {
      assert(newL.count == grid[0].count)
      newG.append(newL)
      newL = [Character]()
    }
    switch c {
    case ">":
      if grid[Pt2((p.x + 1) % grid[0].count, p.y)] == "." {
        newL.append(".")
        if p.x == grid[p.y].count - 1 {
          assert(newL[0] == ".")
          newL[0] = ">"
        } else {
          //print("hack 1")
          doNext = true
//          grid[Pt2(p.x + 1, p.y)] = ")"
        }
      } else {
        newL.append(">")
      }
    case ")":
      print("hack 2")
      newL.append(">")
    case ".":
      newL.append(".")
    case "v":
      newL.append("v")
    default:
      assert(false)
    }
  }
  assert(newL.count == grid[0].count)
  newG.append(newL)
  assert(grid.count == newG.count)
  grid = newG
//  printGrid()
  //print()
  newG = [[Character]]()
  newL = [Character]()
  var hacks = [Int]()
  for (p, c) in grid.asGrid() {
    if p.y > newG.count {
      assert(newL.count == grid[0].count)
      newG.append(newL)
      newL = [Character]()
    }
    if hacks.contains(p.x) {
      hacks.removeAll() { $0 == p.x }
      newL.append("v")
      continue
    }
    switch c {
    case "v":
      if grid[Pt2(p.x, (p.y + 1) % grid.count)] == "." {
        newL.append(".")
        if p.y == grid.count - 1 {
          assert(newG[0][p.x] == ".")
          newG[0][p.x] = "v"
        } else {
          hacks.append(p.x)
//          grid[Pt2(p.x, p.y + 1)] = ")"
        }
      } else {
        newL.append("v")
      }
    case ")":
      newL.append("v")
    case ".":
      newL.append(".")
    case ">":
      newL.append(">")
    default:
      assert(false)
    }
  }
  assert(newL.count == grid[0].count)
  newG.append(newL)
  assert(grid.count == newG.count)
  grid = newG
  print("done", t)
//  printGrid()
  //print()
  if og == grid {
    break
  } 
}

func printGrid() {
  for y in 0..<grid.count {
    var l = ""
    for x in 0..<grid[y].count {
      l.append(grid[y][x])
    }
    print(l)
  }
}
