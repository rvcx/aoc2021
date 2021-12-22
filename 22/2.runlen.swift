import aoclib

struct Pt3: Hashable {
  var x: Int, y: Int, z: Int
}

struct RangeDict<T: Equatable>: Equatable, CustomStringConvertible {
  struct Entry: Equatable {
    let p: Int
    let v: T
  }
  var d: [Entry] // everything above the key has the given value
  var description: String {
    var out = "["
    for cur in d {
      out += ("\(cur.p): \(cur.v),")
    }
    out.append("]")
    return out
  }
  init(_ v: T) {
    d = [Entry(p: Int.min, v: v)]
  }
  init(d: [Entry]) {
    self.d = d
  }
  func mapRange(_ begin: Int, _ end: Int, transform: (T)->T) -> Self {
    var nd = [Entry]()
    var i = 0
    assert(!d.isEmpty)
    var pV = d[0].v
    while i < d.count && d[i].p < begin {
      pV = d[i].v
      nd.append(d[i])
      i += 1
    }
    let newV1 = transform(pV)
    if nd.isEmpty || newV1 != nd.last!.v { 
      nd.append(Entry(p: begin, v: newV1))
      assert(nd.count == 1 || nd[nd.count - 1].p >= nd[nd.count - 2].p)
    }
    while i < d.count && end > d[i].p {
      pV = d[i].v
      let newV = transform(pV)
      if nd.isEmpty || newV != nd.last!.v { 
        nd.append(Entry(p: d[i].p, v: newV))
        assert(nd.count == 1 || nd[nd.count - 1].p >= nd[nd.count - 2].p)
      }
      i += 1
    }
    if nd.isEmpty || pV != nd.last!.v { 
      nd.append(Entry(p: end, v: pV))
      assert(nd.count == 1 || nd[nd.count - 1].p >= nd[nd.count - 2].p,
             "\(self), \(begin), \(end), \(nd), \(i)")
    }
    nd += d[i...]
    return Self(d: nd)
  }
  func count(countFunc: (T)->Int) -> Int {
    print(self)
    var out = 0
    assert(!d.isEmpty)
    for i in 1..<d.count {
      let n = countFunc(d[i - 1].v)
      if n != 0 {
        out += (d[i].p - d[i - 1].p) * n
      }
      print("a: \(n) \(out)")
    }
    let n = countFunc(d.last!.v)
    if n != 0 {
      out += (Int.max - d.last!.p) * n
    }
    print("b: \(n) \(out)")
    return out
  }
}

var on = RangeDict<RangeDict<RangeDict<Bool>>>(
  RangeDict<RangeDict<Bool>>(
    RangeDict<Bool>(false)
  )
)
for l in lines(file: "input.txt").map({ $0.split() }) {
  let turnon = (l[0] == "on")
  let nums = l[1].split(separator: ",").map {
                $0.slice(2).split("..").map { Int($0)! } }
  on = on.mapRange(nums[0][0], nums[0][1] + 1) {
    $0.mapRange(nums[1][0], nums[1][1] + 1) {
      $0.mapRange(nums[2][0], nums[2][1] + 1) {
        let _  = $0
        return turnon
      }
    }
  }
}

print(on)

print(on.count { $0.count { $0.count { $0 ? 1 : 0 } } })
  
//  if turnon {
//    let sx = max(-50, nums[0][0]), fx = min(50, nums[0][1])
//    if sx <= fx {
//      for x in sx...fx {
//        let sy = max(-50, nums[1][0]), fy = min(50, nums[1][1])
//        if sy <= fy {
//          for y in sy...fy {
//            let sz = max(-50, nums[2][0]), fz = min(50, nums[2][1])
//            if sz <= fz {
//              for z in sz...fz {
//                on.insert(Pt3(x: x, y: y, z: z))
//              }
//            }
//          }
//        }
//      }
//    }
//  } else {
//    let sx = max(-50, nums[0][0]), fx = min(50, nums[0][1])
//    if sx <= fx {
//      for x in sx...fx {
//        let sy = max(-50, nums[1][0]), fy = min(50, nums[1][1])
//        if sy <= fy {
//          for y in sy...fy {
//            let sz = max(-50, nums[2][0]), fz = min(50, nums[2][1])
//            if sz <= fz {
//              for z in sz...fz {
//                on.remove(Pt3(x: x, y: y, z: z))
//              }
//            }
//          }
//        }
//      }
//    }
//  }
////  print(on.count)
//}
//
//var out = 0
//for x in -50...50 {
//  for y in -50...50 {
//    for z in -50...50 {
//      if on.contains(Pt3(x: x, y: y, z: z)) {
//        out += 1
//      }
//    }
//  }
//}
//print()
//print(out)