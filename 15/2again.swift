import aoclib

var grid = digitGrid(lines().map { String($0) })

struct Pt3: Hashable {
  let x: Int
  let y: Int
  let z: Int
}

func val(_ x: Int, _ y: Int) -> Int {
  let newV = grid[y % grid.count][x % grid.count] + x / grid.count + y / grid.count
  return (newV - 1) % 9 + 1
}

func neighbors(_ p: Pt3) -> [Pt3] {
  if p.z < val(p.x, p.y) {
    return [Pt3(x: p.x, y: p.y, z: p.z + 1)]
  }
  var out = [Pt3]()
  if p.x > 0 { out.append(Pt3(x: p.x - 1, y: p.y, z: 1)) }
  if p.y > 0 { out.append(Pt3(x: p.x, y: p.y - 1, z: 1)) }
  if p.x < grid.count * 5 - 1 { out.append(Pt3(x: p.x + 1, y: p.y, z: 1)) }
  if p.y < grid.count * 5 - 1 { out.append(Pt3(x: p.x, y: p.y + 1, z: 1)) }
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

//print(ds)
print(ds[Pt3(x: 499, y: 499, z: ((grid[99][99] + 4 + 4) - 1) % 9 + 1)]!)