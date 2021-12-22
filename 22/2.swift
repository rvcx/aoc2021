import aoclib

struct Pt3: Hashable {
  var x: Int, y: Int, z: Int
}
var cubes = [(Bool, Pt3, Pt3)]()
for l in lines(file: "test1.txt").map({ $0.split() }) {
  let turnon = (l[0] == "on")
  let nums = l[1].split(separator: ",").map {
                $0.slice(2).split("..").map { Int($0)! } }
  cubes.append((turnon, Pt3(x: nums[0][0], y: nums[1][0], z: nums[2][0]),
                        Pt3(x: nums[0][1], y: nums[1][1], z: nums[2][1])))
}

struct Cube: Hashable {
  var s: Pt3, f: Pt3
  func contains(_ p: Pt3) -> Bool {
    return p.x >= s.x && p.y >= s.y && p.z >= s.z &&
           p.x <= f.x && p.y <= f.y && p.z <= f.z
  }
  func overlaps(_ o: Cube) -> Bool {
    if s.x > o.f.x || o.s.x > f.x { return false }
    if s.y > o.f.y || o.s.y > f.y { return false }
    if s.z > o.f.z || o.s.z > f.z { return false }
    return true
  }
  var isEmpty: Bool { s.x > f.x || s.y > f.y || s.z > f.z }
}

func deconstruct(a: Cube, b: Cube)
    -> (justA: [Cube], justB: [Cube], both: [Cube]) {
  var justA = [Cube](), justB = [Cube](), both = [Cube]()
  for xr in [(min(a.s.x, b.s.x), max(a.s.x, b.s.x) - 1),
             (max(a.s.x, b.s.x), min(a.f.x, b.f.x)),
             (min(a.f.x, b.f.x) + 1, max(a.f.x, b.f.x))] {
    for yr in [(min(a.s.y, b.s.y), max(a.s.y, b.s.y) - 1),
               (max(a.s.y, b.s.y), min(a.f.y, b.f.y)),
               (min(a.f.y, b.f.y) + 1, max(a.f.y, b.f.y))] {
      for zr in [(min(a.s.z, b.s.z), max(a.s.z, b.s.z) - 1),
                 (max(a.s.z, b.s.z), min(a.f.z, b.f.z)),
                 (min(a.f.z, b.f.z) + 1, max(a.f.z, b.f.z))] {
        let c = Cube(s: Pt3(x: xr.0, y: yr.0, z: zr.0),
                     f: Pt3(x: xr.1, y: yr.1, z: zr.1))
        if !c.isEmpty {
          let inA = a.contains(c.s), inB = b.contains(c.s)
          if inA && inB {
            both.append(c)
          } else if inA {
            justA.append(c)
          } else if inB {
            justB.append(c)
          }
        }
      }
    }
  }
  return (justA: justA, justB: justB, both: both)
}

var on = [Cube]()
for (turnOn, s, f) in cubes {
//  print(on)
  var newOn = [Cube]()
  var fresh = [Cube(s: s, f: f)]
  let cq = Queue<Cube>()
  for c in on { cq.push(c) }
  while let c = cq.pop() {
    var handled = false
    var newFresh = [Cube]()
    for f in fresh {
      if !c.overlaps(f) {
        newFresh.append(f)
        continue
      }
      assert(!handled)
      handled = true
      let d = deconstruct(a: c, b: f)
      for i in d.justA { cq.push(i) }
      newOn += d.justA
      newFresh += d.justB
      if turnOn {
        newOn += d.both
      }
      break
    }
    fresh = newFresh
    if !handled {
      newOn.append(c)
    }
  }
  if turnOn {
    newOn += fresh
  }
  on = newOn
}

var out = 0
for c in Set<Cube>(on) {
  out += (c.f.x - c.s.x + 1) * (c.f.y - c.s.y + 1) * (c.f.z - c.s.z + 1)
}
print(out)
