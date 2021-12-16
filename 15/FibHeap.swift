
public
class FibHeap<T: Comparable> {
  class Node {
    var parent: Node? = nil
    var child: Node? = nil
    weak var left: Node!
    var right: Node!
    var degree = 0
    var mark = false
    var value: T
  
    init(_ value: T) {
      self.value = value
      self.left = self
      self.right = self
    }
  
    func merge(with: Node) {
      assert(right != nil, "\(value)")
      right.left = with.left
      with.left.right = right
      right = with
      with.left = self
    }
  
    struct Sibs: Sequence, IteratorProtocol {
      let start: Node
      var cur: Node?
      mutating func next() -> Node? {
        if let out = cur {
          cur = out.right === start ? nil : out.right
          return out
        }
        return nil
      }
    }
  
    var sibs: Sibs { Sibs(start: self, cur: self) }

    func decrease(to: T, heap: FibHeap) {
      guard right != nil else { return }
      assert(to <= value)
      value = to
      if let p = parent, p.value > value {
        extract(heap)
      }
      assert(heap.n != nil)
      if value < heap.n!.value {
        heap.n = self
      }
    }
    
    func extract(_ heap: FibHeap) {
      left.right = right
      right.left = left
      assert(parent != nil)
      let p = parent!
      p.degree -= 1
      if p.child === self {
        p.child = left === self ? nil : left
      }
      parent = nil
      (left, right) = (self, self)
      assert(heap.n != nil)
      heap.n!.merge(with: self)
      self.mark = false
      if p.parent != nil {
        if p.mark {
          p.extract(heap)
        } else {
          p.mark = true
        }
      }
    }
  }

  var n: Node? = nil
  
  public init() {}

  public func insert(_ v: T) -> (T) -> Void {
    let newNode = Node(v)
    if let root = n {
      root.merge(with: newNode)
      if root.value > v {
        n = newNode
      }
    } else {
      n = newNode
    }
    return { newNode.decrease(to: $0, heap: self) }
  }
  
  func consolidate() {
    assert(n != nil)
    let roots = [Node](n!.sibs)
    var degrees = [Int:Node]()
    for r in roots {
      var x = r
      var d = x.degree
      while var y = degrees.removeValue(forKey: d) {
        if x.value > y.value {
          (x, y) = (y, x)
        }
        y.left.right = y.right
        y.right.left = y.left
        (y.left, y.right) = (y, y)
        if let c = x.child {
          c.merge(with: y)
        } else {
          x.child = y
        }
        y.parent = x
        x.degree += 1
        y.mark = false
        d += 1
      }
      assert(degrees[d] == nil)
      degrees[d] = x
    }
    n = nil
    for (_, r) in degrees {
      if n?.value ?? r.value >= r.value {
        n = r
      }
    }
  }
  
  public func pop() -> T? {
    guard let z = n else {
      return nil
    }
    if let c = z.child {
      for x in c.sibs {
        x.parent = nil
      }
      z.merge(with: c)
    }
    if z.right === z {
      n = nil
    } else {
      z.left.right = z.right
      z.right.left = z.left
      n = z.right
      consolidate()
    }
    z.right = nil
    return z.value
  }
  
}

import Foundation

@available(macOS 10.15, *)
func time(_ f: ()->Void) {
  let start = DispatchTime.now()
  f()
  let elapsed = start.distance(to: DispatchTime.now())
  switch elapsed {
  case .seconds(let v):
    print("\(v)s")
  case .milliseconds(let v):
    print("\(v)ms")
  case .microseconds(let v):
    print("\(v)us")
  case .nanoseconds(let v):
    print("\(v)ns")
  case .never:
    print("no time recorded")
  @unknown default:
    print("unknown time interval")
  }
}

final class StdErrStream: TextOutputStream {
  func write(_ s: String) {
    FileHandle.standardError.write(Data(s.utf8))
  }
}
var stderr = StdErrStream()

func log(_ items: Any..., separator: String=" ", terminator: String="\n") {
  print(items, separator: separator, terminator: terminator, to: &stderr)
}

/*
let n = 10000
let h = FibHeap<Int>()
var updaters = [((Int)->Void, Int)]()
var output = [Int]()
for _ in 1...Int.random(in: 1...n) { // do up to n operations
  switch Int.random(in: 0...2) {
  case 0:
    let d = Int.random(in: 0..<n)
//    log("inserting \(d)")
    updaters.append((h.insert(d), d))
    h.assertInvariants()
  case 1:
//    log("popped", terminator: "")
    if let v = h.pop() {
      output.append(v)
//      log(" \(output.last!)")
    }
    h.assertInvariants()
  case 2:
    if updaters.isEmpty { break }
    let i = Int.random(in: 0..<updaters.count)
    let nv = Int.random(in: 0...updaters[i].1)
//    log("decreasing \(updaters[i].1) to \(nv)")
    updaters[i].0(nv)
    updaters[i] = (updaters[i].0, nv)
    h.assertInvariants()
  default:
    assert(false)
  }
}
while let v = h.pop() {
  output.append(v)
}
*/
//assert(output == output.sorted(), "\(output), \(output.sorted())")

// To aid testing:
extension FibHeap.Node {    
  func assertInvariants() {
    if let c = child {
      for cc in c.sibs {
        assert(cc.parent === self)
        assert(value <= cc.value, "\(value), \(cc.value)")
        cc.assertInvariants()
      }
    }
  }
}

extension FibHeap {
  func assertInvariants() {
    if let c = n {
      for cc in c.sibs {
        assert(c.value <= cc.value)
        cc.assertInvariants()
      }
    }
  }
}


// For visualization:
extension FibHeap.Node {
  func forEdges(id: inout Int, _ f: ((Int, T), (Int, T)) -> Void) {
    let myId = id
    id += 1
    guard let c = child else { return }
    for d in c.sibs {
      f((myId, value), (id, d.value))
      d.forEdges(id: &id, f)
    }
  }
  func forNodes(id: inout Int, _ f: ((Int, T)) -> Void) {
    f((id, value))
    id += 1
    guard let c = child else { return }
    for d in c.sibs {
      d.forNodes(id: &id, f)
    }
  }    
}

extension FibHeap {
  func forEdges(_ f: ((Int, T), (Int, T)) -> Void) {
    guard let root = n else { return }
    var id = 1
    for r in root.sibs {
      r.forEdges(id: &id, f)
    }
  }
  
  func forNodes(_ f: ((Int, T)) -> Void) {
    guard let root = n else { return }
    var id = 1
    for r in root.sibs {
      r.forNodes(id: &id, f)
    }
  }
  
  func printDot() {
    print("digraph {")
    forNodes {
      print("n\($0.0) [label=\"\($0.1)\"];")
    }
    forEdges {
      print("n\($0.0) -> n\($1.0);")
    }
    print("}") 
  }
}
