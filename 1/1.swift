import aoclib

var data = lines(file: "input").map { Int($0) }

var out = 0

var prev = data[0]!
for n in data[1...] {
  if n! > prev {
    out += 1
  }
  prev = n!
}

print(out)