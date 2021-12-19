import aoclib

struct Pt3: Hashable {
  var x: Int, y: Int, z: Int
  init(_ ix: Int, _ iy: Int, _ iz: Int) {
    x = ix
    y = iy
    z = iz
  }
}

struct Rotation: Hashable {
  let x: Int, y: Int, z: Int
}

func rotate(_ p: Pt3, _ r: Rotation) -> Pt3 {
  var out = p
  for _ in 0...r.x {
    let newp = Pt3(out.x, out.z, -out.y)
    out = newp
  }
  for _ in 0...r.y {
    let newp = Pt3(-out.z, out.y, out.x)
    out = newp
  }
  for _ in 0...r.z {
    let newp = Pt3(out.y, -out.x, out.z)
    out = newp
  }
  return out
}

var allRotations = [Rotation]()
for xt in 0..<4 {
  for yt in 0..<4 {
    for zt in 0..<4 {
      allRotations.append(Rotation(x: xt, y: yt, z: zt))
    }
  }
}

var scanners = [[Pt3]]()
for r in records() {
  var beacons = [Pt3]()
  for l in r[1...] {
    let cs = l.split(separator: ",")
    beacons.append(Pt3(Int(cs[0])!, Int(cs[1])!, Int(cs[2])!))
  }
  scanners.append(beacons)
}

struct Transform: Hashable {
  let r: Rotation
  let t: Pt3
}

func match(origin: [Pt3], to: Set<[Pt3]>)
    -> [[Pt3]:(r: Rotation, t: Pt3, a: [Pt3])] {
  var out = [[Pt3]:(r: Rotation, t: Pt3, a: [Pt3])]()
  sloop: for s in to {
    for r in allRotations {
      let rs = s.map { rotate($0, r) }
      for ba in origin {
        for bb in rs {
          let translation = Pt3(ba.x - bb.x, ba.y - bb.y, ba.z - bb.z)
          let rts = rs.map { Pt3(translation.x + $0.x,
                                 translation.y + $0.y,
                                 translation.z + $0.z) }
          let os = Set<Pt3>(origin)
          let ss = Set<Pt3>(rts)
          let i = os.intersection(ss)
          if i.count == 12 {
            out[s] = (r: r, t: translation, a: rts)
            continue sloop
          }
        }
      }
    }
  }
  return out
}

var solved = [[Pt3]:(r: Rotation, t: Pt3, a: [Pt3])]()
solved[scanners[0]] = (r: Rotation(x: 0, y: 0, z: 0), t: Pt3(0, 0, 0),
                       a: scanners[0])

var unsolved = Set<[Pt3]>(scanners[1...])

var q = Queue<[Pt3]>()
q.push(scanners[0])

while !unsolved.isEmpty, let o = q.pop() {
  for (k, v) in match(origin: o, to: unsolved) {
    print("solved; \(unsolved.count) remaining")
    solved[k] = v
    unsolved.remove(k)
    q.push(v.a)
  }
}

var allScanners = Set<Pt3>()
for (_, v) in solved {
  allScanners.insert(v.t)
}

var m = 0
for a in allScanners {
  for b in allScanners {
    print(a, b, m)
    m = max(m, abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z))
  }
}
print(allScanners.count)
print(m)