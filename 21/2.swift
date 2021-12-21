import aoclib

var p1 = 2
var p2 = 7

//p1 = 4
//p2 = 8

p1 -= 1
p2 -= 1

var rolls = 0

func roll() -> Int {
  rolls += 1
  return rolls % 100
}

var states = [[Int]:Int]()
states[[p1, 0, p2, 0]] = 1

var p1score = 0, p2score = 0

while !states.isEmpty {
  var nstates = [[Int]:Int]()
  for (k, v) in states {
    for r1 in 1...3 {
      for r2 in 1...3 {
        for r3 in 1...3 {
          let npos = (k[0] + r1 + r2 + r3) % 10
          let nscore = k[1] + npos + 1
          if nscore >= 21 {
            p1score += v
            continue
          } else {
            let nk = [npos, nscore, k[2], k[3]]
            if nstates[nk] == nil {
              nstates[nk] = 0
            }
            nstates[nk]! += v
          }
        }
      }
    }
  }
  states = nstates
  nstates = [[Int]:Int]()
  for (k, v) in states {
    for r1 in 1...3 {
      for r2 in 1...3 {
        for r3 in 1...3 {
          let npos = (k[2] + r1 + r2 + r3) % 10
          let nscore = k[3] + npos + 1
          if nscore >= 21 {
            p2score += v
            continue
          } else {
            let nk = [k[0], k[1], npos, nscore]
            if nstates[nk] == nil {
              nstates[nk] = 0
            }
            nstates[nk]! += v
          }
        }
      }
    }
  }
  states = nstates
//  p1 += roll() + roll() + roll()
//  p1 %= 10
//  p1score += (p1 % 10 + 1)
//  if p1score >= 1000 {
//    print(p2score * rolls)
//    break
//  }
//  p2 += roll() + roll() + roll()
//  p2 %= 10
//  p2score += (p2 % 10 + 1)
//  if p2score >= 1000 {
//    print(p1score * rolls)
//    break
//  }
//  print(p1, p1score, p2, p2score)
}

print(p1score, p2score, max(p1score, p2score))