import aoclib

var grid = digitGrid(lines().map { String($0) })

struct Pt3: Hashable {
  let x: Int
  let y: Int
  let z: Int
}

func neighbors(_ p: Pt3) -> [Pt3] {
  if p.z < grid[p.y][p.x] {
    return [Pt3(x: p.x, y: p.y, z: p.z + 1)]
  }
  var out = [Pt3]()
  if p.x > 0 { out.append(Pt3(x: p.x - 1, y: p.y, z: 1)) }
  if p.y > 0 { out.append(Pt3(x: p.x, y: p.y - 1, z: 1)) }
  if p.x < grid.count - 1 { out.append(Pt3(x: p.x + 1, y: p.y, z: 1)) }
  if p.y < grid.count - 1 { out.append(Pt3(x: p.x, y: p.y + 1, z: 1)) }
  return out
}

var q = Queue<Pt3>()
q.push(Pt3(x: 0, y: 0, z: grid[0][0]))

var ds = [Pt3(x: 0, y: 0, z: grid[0][0]): 0]

while let p = q.pop() {
  for n in neighbors(p) {
    if ds[n] == nil {
      ds[n] = ds[p]! + 1
      q.push(n)
    }
  }
}

print(ds[Pt3(x: 99, y: 99, z: grid[99][99])]!)