import aoclib

var data = lines()

let closes: [Character:Character] = [ "(": ")", "[": "]", "{": "}", "<": ">" ]
func parseChunks(_ s: String, _ pos: inout Int, _ completion: inout String)
    -> Character? {
  print("parsing")
  while pos < s.count && "([{<".contains(s[pos]) {
    let delim = s[pos]
    pos += 1
    if let c = parseChunks(s, &pos, &completion) {
      if c == " " {
        completion.append(closes[delim]!)
      }
      print("incomplete (below)")
      return c
    } else if pos == s.count {
      completion.append(closes[delim]!)
      print("incomplete")
      return " "
    } else if s[pos] != closes[delim] {
      print("corrupt")
      return s[pos]
    }
    pos += 1
  }
  print("valid")
  return nil
}

var outputs = [Int]()

for l in data {
  var output = 0
  var p = 0
  var s = ""
  if let space = parseChunks(String(l), &p, &s) {
    print("parsed", space, "'\(s)'")
    if space != " " { continue }
    for c in s {
      print("doing character", c, output)
      output *= 5
      switch c {
      case " ":
        break
      case ")":
        output += 1
      case "]":
        output += 2
      case "}":
        output += 3
      case ">":
        output += 4
      default:
        print("assertion!")
        assert(false, "my assertion")
      }
    }
  }
  outputs.append(output)
}

outputs.sort()
print(outputs.count, outputs[outputs.count / 2])