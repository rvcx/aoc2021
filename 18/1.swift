import aoclib


class Num: CustomStringConvertible {
  var reg: Int?
  var pair: (Num, Num)?
  
  var description: String {
    if let r = reg {
      return String(describing: r)
    } else {
      var s = "["
      s += String(describing: pair!.0)
      s += ","
      s += String(describing: pair!.1)
      s += "]"
      return s
    }
  }
      
  init(_ v: Int) {
    reg = v
    pair = nil
  }
  init(_ l: Num, _ r: Num) {
    pair = (l, r)
    reg = nil
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
      reg = nil
      pair = (ln, rn)
    } else {
      reg = Int(String(s[pos]))!
      pair = nil
      pos += 1
    }
  }
  
  func addR(_ v: Int) {
    if let r = reg {
      reg = r + v
    } else {
      pair!.1.addR(v)
    }
  }
  func addL(_ v: Int) {
    if let r = reg {
      reg = r + v
    } else {
      pair!.0.addL(v)
    }
  }
  func doExplosions(_ level: Int) -> (Int, Int)? {
    if let p = pair, level > 3 {
      defer {
        reg = 0
        pair = nil
      }
      return (p.0.reg!, p.1.reg!)
    } else {
      if let p = pair {
        if let (lv, rv) = p.0.doExplosions(level + 1) {
          p.1.addL(rv)
          return (lv, 0)
        }
        if let (lv, rv) = p.1.doExplosions(level + 1) {
          p.0.addR(lv)
          return (0, rv)
        }
      }
      return nil
    }
  }
  func doSplits() -> Bool {
    if let r = reg, r >= 10 {
      pair = (Num(r / 2), Num((r + 1) / 2))
      reg = nil
      return true
    }
    if let p = pair {
      return p.0.doSplits() || p.1.doSplits()
    }
    return false
  }
  
  func doReduce() {
    var b = false
    repeat {
      print(self)
      b = doExplosions(0) != nil || doSplits()
    } while b
  }
  
  func mag() -> Int {
    if let r = reg {
      return r
    }
    return pair!.0.mag() * 3 + pair!.1.mag() * 2
  }
}

var data = lines()
var pos = 0
var n = Num(data[0], &pos)

for l in data[1...] {
  pos = 0
  n = Num(n, Num(l, &pos))
  n.doReduce()
}
  
print(n.mag())

var output = 0

print(output)
