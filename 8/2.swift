import aoclib

var data = lines().map { $0.split(" | ") }.map {
  $0[0].split(separator: " ") + $0[1].split(separator: " ")
}

var allPerms = Set<[Character]>()

var s = Set<Character>("abcdefg")
func addPerm(_ remaining: Set<Character>, _ partial: [Character]) {
  guard !remaining.isEmpty else {
    allPerms.insert(partial)
    return
  }
  for c in remaining {
    var newS = remaining
    newS.remove(c)
    var newA = partial
    newA.append(c)
    addPerm(newS, newA)
  }
}
addPerm(s, [])



var positions = [Set<[Character]>](repeating: allPerms, count: 14)

let digitsArray = ["abcefg", "cf", "acdeg", "acdfg", "bcdf",
              "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"].map {
  Set<Character>($0)
}
let digits = Set<Set<Character>>(digitsArray)
//print(digits)

var output = 0
for line in data {
  for mapping in allPerms {
    var attemptedDigits = Set<Set<Character>>()
    for digit in line[..<10] {
      var wires = Set<Character>()
      for c in digit {
        wires.insert(mapping[Int(c.asciiValue! - Character("a").asciiValue!)])
      }
      attemptedDigits.insert(wires)
    }
    if attemptedDigits == digits {
      var outVal = 0
      for digit in line[10...] {
        var wires = Set<Character>()
        for c in digit {
          wires.insert(mapping[Int(c.asciiValue! - Character("a").asciiValue!)])
        }
        outVal *= 10
        outVal += digitsArray.firstIndex(of: wires)!
      }
      print(outVal)
      output += outVal
      //break
    }
  }
}
print(output)
//  for (p, dig) in line.enumerated() {
//    var newMappings = Set<[Character]>()
//    for mapping in positions[p] {
//      var wires = Set<Character>()
//      for c in dig {
//        wires.insert(mapping[Int(c.asciiValue! - Character("a").asciiValue!)])
//      }
//      print(wires, p)
//      if digits.contains(wires) {
////        print("adding", mapping)
//        newMappings.insert(mapping)
//      } else {
////        print("eliminating", mapping, p)
//      }
//    }
//    positions[p] = newMappings
//  }
//}

//print(positions.map { $0.count })