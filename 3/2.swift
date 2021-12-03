import aoclib

var data = lines().map { String($0) }

//data  = [
//"00100",
//"11110",
//"10110",
//"10111",
//"10101",
//"01111",
//"00111",
//"11100",
//"10000",
//"11001",
//"00010",
//"01010"]

var output = 0

func countOnes(_ data: [String]) -> [Int] {
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

  return bitpos
}

let odata = data


  var curBitA = 0
  while data.count > 1 {
    print(data)
    let crit = countOnes(data)
    let v = crit[curBitA] >= (data.count + 1) / 2 ? Character("1") : Character("0")
    data = data.filter { $0[curBitA] == v }
    curBitA += 1
  }


let gamma = data[0]
print(gamma)

data = odata
var curBit = 0
while data.count > 1 {
  let crit = countOnes(data)
  let v = crit[curBit] >= (data.count + 1) / 2 ? Character("0") : Character("1")
  data = data.filter { $0[curBit] == v }
  curBit += 1
}

let eps = data[0]
print(eps)

func fromBinary(_ s: String) -> Int {
  var out = 0
  for c in s {
    out *= 2
    if c == "1" {
      out += 1
    } else {
      assert(c == "0")
    }
  }
  return out
}

print(fromBinary(gamma) * fromBinary(eps))
