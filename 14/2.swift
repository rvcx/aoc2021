import aoclib

var data = lines(file: "input.txt").map { $0.split(" -> ") }

var m = [String:String]()
for d in data {
  assert(m[String(d[0])] == nil)
  m[String(d[0])] = String(d[1])
}
//print(m)

struct CacheKey : Hashable {
  let k: String
  let v: String
  let l: Int
}
var cache = [CacheKey: [String:Int]]()

func changesForRule(_ k: String, _ v: String, levels: Int) -> [String:Int] {
  if levels == 0 {
    return [String:Int]()
  }
  let ck = CacheKey(k: k, v: v, l: levels)
  print(ck)
  if let r = cache[ck] {
    return r
  }
  var changes = [String:Int]()
  if changes[v] == nil { changes[v] = 0 }
  changes[v]! += 1
  for nextk in [String(k[0]) + v, v + String(k[1])] {
    if let nextv = m[nextk] {
      for (c, i) in changesForRule(nextk, nextv, levels: levels - 1) {
        if changes[c] == nil { changes[c] = 0 }
        changes[c]! += i
      }
    }
  }
  cache[ck] = changes
  return changes
}

var ruleImpact = [String:[String:Int]]()
for (k, v) in m {
  ruleImpact[k] = changesForRule(k, v, levels: 39)
}

print(ruleImpact)
var s = "CKKOHNSBPCPCHVNKHFFK"
//var s = "NNCB"

var totalImpact = [String:Int]()
for pos in 1..<s.count {
  let pair = String(s.slice((pos - 1), (pos + 1)))
  if let r = m[pair] {
    for (c, i) in changesForRule(pair, r, levels: 40) {
      if totalImpact[c] == nil { totalImpact[c] = 0 }
      totalImpact[c]! += i
    }
  }
}

for c in s {
  totalImpact[String(c)]! += 1
}
print(totalImpact.values.max()!, totalImpact.values.min()!,
      totalImpact.values.max()! - totalImpact.values.min()!)
//  print(freqs.values.max()!, freqs.values.min()!)

