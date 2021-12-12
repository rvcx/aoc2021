import aoclib

var data = lines(file: "input.txt").map { $0.split(separator: "-").map { String($0) } }

var nexts = [String: Set<String>]()
var rooms = Set<String>()
for l in data {
  rooms.insert(l[0])
  rooms.insert(l[1])
  if var s = nexts[l[0]] {
    s.insert(l[1])
    nexts[l[0]] = s
  } else {
    var s = Set<String>()
    s.insert(l[1])
    nexts[l[0]] = s
  }
  if var s = nexts[l[1]] {
    s.insert(l[0])
    nexts[l[1]] = s
  } else {
    var s = Set<String>()
    s.insert(l[0])
    nexts[l[1]] = s
  }
}

func explore(_ path: [String], visited: Set<String>, doubled: Bool)
    -> [[String]] {
  print(path)
  assert(!path.isEmpty)
  var out = [[String]]()
  for n in nexts[path[path.count - 1]] ?? Set<String>() {
    print(n)
    if !visited.contains(n) {
      var np = path
      np.append(n)
      if n == "end" {
        out.append(np)
      } else {
        var newv = visited
        if n.allSatisfy({ $0.isLowercase }) {
          newv.insert(n)
        }
        out += explore(np, visited: newv, doubled: doubled)
      }
    } else if n != "start" && !doubled {
      var np = path
      np.append(n)
      if n == "end" {
        out.append(np)
      } else {
        var newv = visited
        if n.allSatisfy({ $0.isLowercase }) {
          newv.insert(n)
        }
        out += explore(np, visited: newv, doubled: true)
      }
    }
  }
  return out
}


var v = Set<String>()
v.insert("start")
var output = Set<[String]>(explore(["start"], visited: v, doubled: false))

//print(nexts)
for p in output {
  print(p)
}
print(output.count)
