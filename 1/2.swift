import aoclib

var data = lines(file: "input").map { Int($0)! }

var out = 0

var (a, b, c) = (data[0], data[1], data[2])
for n in data[3...] {
  if a + b + c < b + c + n {
    out += 1
  }
  a = b
  b = c
  c = n
}

print(out)