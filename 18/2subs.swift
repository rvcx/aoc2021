import aoclib


class Num: CustomStringConvertible {
  init() {}
  var description: String { return "pure virtual" }
  func addR(_ v: Int) { fatalError("pure virtual") }
  func addL(_ v: Int) { fatalError("pure virtual") }
  func doExplosions(_ level: Int) -> (Int, Int, Num)? { fatalError("pure virtual") }
  func doSplits() -> Num? { fatalError("pure virtual") }
  func doReduce() {
    var b = false
    repeat {
      b = doExplosions(0) != nil || doSplits() != nil
    } while b
  }  
  func mag() -> Int { fatalError("pure virtual") }
}

class Regular: Num {
  var r: Int
  
  init(r: Int) {
    self.r = r
  }
  
  override var description: String {
    return String(describing: r)
  }

  override func addR(_ v: Int) {
    r += v
  }
  override func addL(_ v: Int) {
    r += v
  }

  override func doExplosions(_ level: Int) -> (Int, Int, Num)? {
    return nil
  }

  override func doSplits() -> Num? {
    if r >= 10 {
      return Pair(l: Regular(r: r / 2), r: Regular(r: (r + 1) / 2))
    }
    return nil
  }
    
  override func mag() -> Int {
    return r
  }
}

class Pair: Num {
  var l: Num
  var r: Num
  
  init(l: Num, r: Num) {
    self.l = l
    self.r = r
  }

  override var description: String {
    var s = "["
    s += String(describing: l)
    s += ","
    s += String(describing: r)
    s += "]"
    return s
  }

  override func addR(_ v: Int) {
    r.addR(v)
  }
  override func addL(_ v: Int) {
    l.addL(v)
  }

  override func doExplosions(_ level: Int) -> (Int, Int, Num)? {
    if level > 3 {
      if let lr = l as? Regular, let rr = r as? Regular {
        return (lr.r, rr.r, Regular(r: 0))
      } else {
        assert(false)
      }
    } else {
      if let (lv, rv, newl) = l.doExplosions(level + 1) {
        l = newl
        r.addL(rv)
        return (lv, 0, self)
      }
      if let (lv, rv, newr) = r.doExplosions(level + 1) {
        r = newr
        l.addR(lv)
        return (0, rv, self)
      }
    }
    return nil
  }

  override func doSplits() -> Num? {
    if let newl = l.doSplits() {
      l = newl
      return self
    } else if let newr = r.doSplits() {
      r = newr
      return self
    }
    return nil
  }
  
  override func mag() -> Int {
    return l.mag() * 3 + r.mag() * 2
  }
}

extension Num {
  static func parse<T: StringProtocol>(_ s: T, _ pos: inout Int) -> Num {
    if s[pos] == "[" {
      pos += 1
      let ln = Num.parse(s, &pos)
      assert(s[pos] == ",")
      pos += 1
      let rn = Num.parse(s, &pos)
      assert(s[pos] == "]")
      pos += 1
      return Pair(l: ln, r: rn)
    } else {
      let n = Int(String(s[pos]))!
      pos += 1
      return Regular(r: n)
    }
  }
}

var data = lines()
var pos = 0

var out = 0
for i in 0..<data.count {
  for j in 0..<data.count {
    pos = 0
    let n = Num.parse(data[i], &pos)
    pos = 0
    let m = Num.parse(data[j], &pos)
    let x = Pair(l: n, r: m)
    x.doReduce()
    out = max(x.mag(), out)
  }
}
print(out)
