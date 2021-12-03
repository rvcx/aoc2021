import aoclib

var data = lines()

var output = 0

var bitpos = [ 0,0,0,0,0,0,0,0,0,0,0,0 ]

for s in data {
  var pos = 0
  for c in s {
    switch c {
    case "0":
      break
    case "1":
      bitpos[pos] += 1
    default:
      assert(false)
    }
    pos += 1
  }
}

var gamma = 0
var eps = 0

for p in bitpos {
  gamma *= 2
  eps *= 2
  if p > data.count / 2{
    gamma += 1
  } else {
    eps += 1
  }
}

print(gamma, eps, gamma * eps)