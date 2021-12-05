import aoclib

var data = try! String(contentsOfFile: "input.txt").split(separator: "\n", omittingEmptySubsequences: false)

let header = data[0].split(",").map { Int($0)! }

var block = [[Int]]()

var boards = [[[Int]]]()

for l in data[2...] {
  if l == "" {
    boards.append(block) 
    block = []
  } else {
    var a = [Int]()
    for s in l.split(" ") {
      if s != "" && s != " " && s != "  " && s != "   " {
        a.append(Int(s)!)
      }
    }
    block.append(a)
  }
}

var haventWon = Set<[[Int]]>(boards)


func wins(_ board: [[Int]], called: Set<Int>) -> Bool {
  assert(board.count == 5)
  rowLoop: for row in board {
    assert(row.count == 5)
    for n in row {
      if !called.contains(n) {
        continue rowLoop
      }
    }
    print("row win")
    return true
  }
  colLoop: for col in 0..<5 {
    for row in board {
      if !called.contains(row[col]) {
        continue colLoop
      }
    }
    print("col win", col)
    return true
  }
  return false
}

var called = Set<Int>()
outer: for n in header {
  called.insert(n)
  for board in boards {
    if haventWon.contains(board) && wins(board, called: called) {
      haventWon.remove(board)
      var tot = 0
      for row in board {
        for cn in row {
          if !called.contains(cn) {
            tot += cn
          }
        }
      }
      print(board)
      print([Int](called).sorted())
      print(tot, n, tot * n)
    }
  }
}
