import aoclib

var data = lines().map { $0.split(" -> ") }

var hasVent = Set<[Int]>()
var overlaps = Set<[Int]>()
var output = 0


for d in data {
  assert(d.count == 2)
  let v = d[0].split(",").map { Int($0)! }
  let (sx, sy) = (v[0], v[1])
  let ends = d[1].split(",").map { Int($0)! }
  let (ex, ey) = (ends[0], ends[1])
  
  if sx == ex {
    let ran = sy < ey ? sy...ey : ey...sy
    for y in ran {
      let pos = [sx, y]
      if hasVent.contains(pos) {
        overlaps.insert(pos)
      }
      hasVent.insert(pos)
    }
  } else if sy == ey {
    let ran = sx < ex ? sx...ex : ex...sx
    for x in ran {
      let pos = [x, sy]
      if hasVent.contains(pos) {
        overlaps.insert(pos)
      }
      hasVent.insert(pos)
    }
  } else if sx - ex == sy - ey {
    let bx = min(sx, ex)
    let fx = max(sx, ex)
    let by = min(sy, ey)
    let fy = max(sy, ey)
    assert((bx, by) == (sx, sy) || (bx, by) == (ex, ey))
    assert(fx - bx == fy - by)
    for i in 0...(fx - bx) {
      let pos = [bx + i, by + i]
      if hasVent.contains(pos) {
        overlaps.insert(pos)
      }
      hasVent.insert(pos)
    }
  } else {
    assert(sx - ex == -(sy - ey))
    let bx = min(sx, ex)
    let fx = max(sx, ex)
    let by = min(sy, ey)
    let fy = max(sy, ey)
    assert(fx - bx == fy - by)
    for i in 0...(fx - bx) {
      let pos = [bx + i, fy - i]
      if hasVent.contains(pos) {
        overlaps.insert(pos)
      }
      hasVent.insert(pos)
    }
  }
}

for x in 0..<1000 {
  var s = ""
  for y in 0..<1000 {
    s += hasVent.contains([x, y]) ? overlaps.contains([x, y]) ? "!" : "*" : " "
  }
//  print(s)    
}
print(overlaps.count)