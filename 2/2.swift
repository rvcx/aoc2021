import aoclib

var data = parseLines(#"(.*) (.*)"#)

var output = 0

var x = 0
var y = 0
var aim = 0

for d in data {
  switch d[0]! {
  case "forward":
    x += Int(d[1]!)!
    y += Int(d[1]!)! * aim
  case "down":
//    y += Int(d[1]!)!
    aim += Int(d[1]!)!
  case "up":
//    y -= Int(d[1]!)!
    aim -= Int(d[1]!)!
  default:
    assert(false)
  }
}

print(x * y)