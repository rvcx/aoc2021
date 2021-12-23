import aoclib

var grid = lines(file: "input2.txt")


var rooms: [Character:[Pt2]] = [
  "A": [Pt2(3, 2), Pt2(3, 3), Pt2(3, 4), Pt2(3, 5)],
  "B": [Pt2(5, 2), Pt2(5, 3), Pt2(5, 4), Pt2(5, 5)],
  "C": [Pt2(7, 2), Pt2(7, 3), Pt2(7, 4), Pt2(7, 5)],
  "D": [Pt2(9, 2), Pt2(9, 3), Pt2(9, 4), Pt2(9, 5)]
]

let halls = [Pt2(1, 1), Pt2(2, 1), Pt2(4, 1), Pt2(6, 1),
             Pt2(8, 1), Pt2(10, 1), Pt2(11, 1)]
let costs: [Character:Int] = ["A": 1, "B": 10, "C": 100, "D": 1000]


//var allRoomPs = rooms["A"]! + rooms["B"] + rooms["C"] + rooms["D"]

var initialState = [(Character, Pt2)]()

for (p, c) in grid.asGrid() {
  if "ABCD".contains(c) {
    initialState.append((c, p))
  }
}
print(initialState)

struct HState: Hashable {
  let c: Character
  let p: Pt2
}
var explored = [[HState]:Int?]()
var dups = 0, fresh = 0
func best(from: [(Character, Pt2)]) -> Int? {
  assert(from.count == 16)
  let memHash = from.map { HState(c: $0.0, p: $0.1) }
  if let r = explored[memHash] {
    return r
  }
  var allDone = true
  for (c, p) in from {
    if !rooms[c]!.contains(p) {
      allDone = false
      break
    }
  }
  if allDone {
    explored[memHash] = 0
    return 0
  }
  var b: Int? = nil
  cloop: for (c, p) in from {
    if halls.contains(p) {
      var dest = rooms[c]![3]
      // move to dest room if possible; otherwise give up
      for (bc, bp) in from {
        if bc != c && rooms[c]!.contains(bp) {
          continue cloop
        }
        if p.x < rooms[c]![0].x && halls.contains(bp) &&
           bp.x > p.x && bp.x < rooms[c]![0].x {
          continue cloop
        }
        if p.x > rooms[c]![0].x && halls.contains(bp) &&
           bp.x < p.x && bp.x > rooms[c]![0].x {
          continue cloop
        }
        if bc == c && rooms[c]!.contains(bp) {
          dest = Pt2(dest.x, min(dest.y, bp.y - 1))
//          if !rooms[c]!.contains(dest) {
//            continue cloop
//          }
        }
      }
      assert(rooms[c]!.contains(dest))
      // not blocked; move!
      let nextState = from.map { $0 == (c, p) ? (c, dest) : $0 }
      let cost = (abs(dest.x - p.x) + abs(dest.y - p.y)) * costs[c]!
      if let b = best(from: nextState) {
        explored[memHash] = b + cost
        return b + cost
      } else {
//        print("there are unsolvable states")
        explored[memHash] = nil
        return nil
      }
    } else {
      // we're in a room
      if rooms[c]!.contains(p) {
        var blocking = false
        for (oc, op) in from {
          if oc != c && rooms[c]!.contains(op) && op.y > p.y {
            blocking = true
            break
          }
        }
        if !blocking {
          continue cloop
        }
      }
      for (_, op) in from {
        if op.x == p.x && op.y < p.y {
          continue cloop
        }
      }
      hloop: for h in halls {
        for (_, bp) in from {
          if p.x < h.x && halls.contains(bp) &&
             bp.x > p.x && bp.x <= h.x {
            continue hloop
          }
          if p.x > h.x && halls.contains(bp) &&
             bp.x < p.x && bp.x >= h.x {
            continue hloop
          }
        }
        let nextState = from.map { $0 == (c, p) ? (c, h) : $0 }
        let cost = (abs(h.x - p.x) + abs(h.y - p.y)) * costs[c]!
        if let nb = best(from: nextState) {
          b = min(b ?? Int.max, nb + cost)
        }
      }
    } // end else
  } // end cloop
  explored[memHash] = b
  return b
}

print(best(from: initialState) ?? "no solution")
