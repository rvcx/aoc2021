import aoclib

var data = lines(file: "input.txt").map { String($0) }

var g = digitGrid(data)
print(g.count, g[0].count)

var bigGrid = [[Int]]()
for l in g {
  let newl = l + l.map { $0 % 9 + 1 } + l.map { ($0 + 1) % 9 + 1 }  +
            l.map { ($0 + 2) % 9 + 1 } + l.map { ($0 + 3) % 9 + 1 }
  bigGrid.append(newl)
}
var biggerGrid = bigGrid
biggerGrid += bigGrid.map { $0.map { $0 % 9 + 1 } }
biggerGrid += bigGrid.map { $0.map { ($0 + 1) % 9 + 1 } }
biggerGrid += bigGrid.map { $0.map { ($0 + 2) % 9 + 1 } }
biggerGrid += bigGrid.map { $0.map { ($0 + 3) % 9 + 1 } }

g = biggerGrid

var ds = [Pt2:Int]()
var ps = [Pt2:Pt2]()

var q = Set<Pt2>()
for (v, _) in g.asGrid() { q.insert(v) }

ds[Pt2(0, 0)] = 0
var visited = Set<Pt2>()

while !q.isEmpty {
  let v = (q.map { ($0, ds[$0] ?? 1000000) }.min { $0.1 < $1.1 })!.0
  q.remove(v)
//  print(v)
  if !visited.insert(v).inserted { continue }
  for p in v.mneighbors(g) {
    if visited.contains(p) { continue }
    let newd = ds[v]! + g[p]
    if newd < (ds[p] ?? 100000000) {
      ds[p] = newd
      ps[p] = v
    }
  }
}

print(ps)
print(ds)
print(ds[Pt2(g.count - 1, g.count - 1)]!)

var c = Pt2(g.count - 1, g.count - 1)
var tot = g[c]
while let n = ps[c] {
  tot += g[n]
  print(n, g[n], tot)
  c = n
}
print(tot)
var output = 0
print(output)