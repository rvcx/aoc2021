import aoclib

var data = try! String(contentsOfFile: "input.txt").split(separator: "\n", omittingEmptySubsequences: false)

var spots = Set<Pt2>()
var i = 0
while !data[i].isEmpty {
  let p = data[i].split(separator: ",")
//  print(p)
  spots.insert(Pt2(Int(p[0])!, Int(p[1])!))
  i += 1
}
for l in data[(i+1)...] {
  if l.isEmpty { break }
  let fields = l.split(separator: "=")
  let axis = fields[0][fields[0].count - 1]
  let n = Int(fields[1])!
  
  var newspots = Set<Pt2>()
  if axis == "x" {
    for p in spots {
      if p.x > n {
        newspots.insert(Pt2(n - (p.x - n), p.y))
      } else {
        newspots.insert(p)
      }
    }
  } else {
    assert(axis == "y")
    for p in spots {
      if p.y > n {
        newspots.insert(Pt2(p.x, n - (p.y - n)))
      } else {
        newspots.insert(p)
      }
    }
  }
  spots = newspots
  print(axis, n)
}  
      

var output = 0

for y in (spots.map {$0.y}.min()!)...(spots.map {$0.y}.max()!) {
  var l = String()
  for x in (spots.map {$0.x}.min()!)...(spots.map {$0.x}.max()!) {
    l.append(spots.contains(Pt2(x, y)) ? "#" : ".")
  }
  print(l)
}
print(output)
print(spots.count)