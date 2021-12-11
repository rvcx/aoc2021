import aoclib

var data = lines()

let closes: [Character:Character] = [ "(": ")", "[": "]", "{": "}", "<": ">" ]
func parseChunks(_ s: String, _ pos: inout Int) -> Character? {
  while pos < s.count && "([{<".contains(s[pos]) {
    let delim = s[pos]
    pos += 1
    if let c = parseChunks(s, &pos) {
      return c
    } else if pos == s.count {
      return " "
    } else if s[pos] != closes[delim] {
      return s[pos]
    }
    pos += 1
  }
  return nil
}

var output = 0

for l in data {
  var p = 0
  if let c = parseChunks(String(l), &p) {
    switch c {
    case " ":
      break
    case ")":
      output += 3
    case "]":
      output += 57
    case "}":
      output += 1197
    case ">":
      output += 25137
    default:
      assert(false)
    }
  }
}

print(output)