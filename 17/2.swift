import aoclib

//let tx = 20...30 //(143...177)
//let ty = -10...(-5) //(-106...(-71))
let tx = (143...177)
let ty = (-106...(-71))
var output = 0

var x = 0
var y = 0

func step(xv: inout Int, yv: inout Int) {
  x += xv
  y += yv
  if xv != 0 {
    xv -= xv > 0 ? 1 : -1
  }
  yv -= 1
}
func hits(xv: Int, yv: Int) -> (Bool, Int) {
  x = 0
  y = 0
  var xv1 = xv
  var yv1 = yv
  var my = -1000
  for _ in 0...300 {
    step(xv: &xv1, yv: &yv1)
    my = max(y, my)
    if tx.contains(x) && ty.contains(y) {
      return (true, my)
    }
  }
  return (false, -1000)
}

var numHits = 0

var best = (-100, -100, -100)
for xv in 1...300 {
  for yv in -400...800 {
    let (b, my) = hits(xv: xv, yv: yv)
    if b {
      numHits += 1
    }
  }
}
print(numHits)
      