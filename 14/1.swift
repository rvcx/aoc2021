import aoclib

var data = lines(file: "input.txt").map { $0.split(" -> ") }

var m = [String:String]()
for d in data {
  assert(m[String(d[0])] == nil)
  m[String(d[0])] = String(d[1])
}
print(m)

var s = "CKKOHNSBPCPCHVNKHFFK"
//var s = "NNCB"

for _ in 0..<10 {
  var ns = ""
  for pos in 1..<s.count {
    let pair = String(s.slice((pos - 1), (pos + 1)))
//    print(pair)
    ns.append(s[pos - 1])
    if let r = m[pair] {
//      print(pair, r)
      ns.append(r)
    }
  }
  ns.append(s.last!)
  s = ns
  print(s)
}

var freqs = [Character: Int]()

for c in s {
  if freqs[c] == nil {
    freqs[c] = 0
  }
  freqs[c]! += 1
}

print(freqs.values.max()! - freqs.values.min()!)
