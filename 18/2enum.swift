import aoclib


enum Num: CustomStringConvertible {
  case regular(Int)
  indirect case pair(Num, Num)
  
  var description: String {
    switch self {
    case .regular(let r):
      return String(describing: r)
    case .pair(let l, let r):
      var s = "["
      s += String(describing: l)
      s += ","
      s += String(describing: r)
      s += "]"
      return s
    }
  }

  init<T: StringProtocol>(_ s: T, _ pos: inout Int) {
    if s[pos] == "[" {
      pos += 1
      let ln = Num(s, &pos)
      assert(s[pos] == ",")
      pos += 1
      let rn = Num(s, &pos)
      assert(s[pos] == "]")
      pos += 1
      self = .pair(ln, rn)
    } else {
      let n = Int(String(s[pos]))!
      pos += 1
      self = .regular(n)
    }
  }

  mutating func addR(_ v: Int) {
    switch self {
    case .regular(let r):
      self = .regular(r + v)
    case .pair(let l, var r):
      r.addR(v)
      self = .pair(l, r)
    }
  }
  mutating func addL(_ v: Int) {
    switch self {
    case .regular(let r):
      self = .regular(r + v)
    case .pair(var l, let r):
      l.addL(v)
      self = .pair(l, r)
    }
  }

  mutating func doExplosions(_ level: Int) -> (Int, Int)? {
    switch self {
    case .regular:
      return nil
    case var .pair(l, r):
      if level > 3 {
        self = .regular(0)
        if case let .regular(lv) = l, case let .regular(rv) = r {
          return (lv, rv)
        } else {
          assert(false)
        }
      } else {
        if let (lv, rv) = l.doExplosions(level + 1) {
          r.addL(rv)
          self = .pair(l, r)
          return (lv, 0)
        }
        if let (lv, rv) = r.doExplosions(level + 1) {
          l.addR(lv)
          self = .pair(l, r)
          return (0, rv)
        }
      }
      return nil
    }
  }

  mutating func doSplits() -> Bool {
    switch self {
    case let .regular(r):
      if r >= 10 {
        self = .pair(.regular(r / 2), .regular((r + 1) / 2))
        return true
      }
      return false
    case var .pair(l, r):
      defer { self = .pair(l, r) }
      return l.doSplits() || r.doSplits()
    }
  }
  
  mutating func doReduce() {
    var b = false
    repeat {
      b = doExplosions(0) != nil || doSplits()
    } while b
  }
  
  func mag() -> Int {
    switch self {
    case let .regular(r):
      return r
    case let .pair(l, r):
      return l.mag() * 3 + r.mag() * 2
    }
  }
}

var data = lines()
var pos = 0

var out = 0
for i in 0..<data.count {
  for j in 0..<data.count {
    pos = 0
    let n = Num(data[i], &pos)
    pos = 0
    let m = Num(data[j], &pos)
    var x = Num.pair(n, m)
    x.doReduce()
    out = max(x.mag(), out)
  }
}
print(out)
