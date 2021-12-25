//import aoclib
//
//enum Exp {
//  indirect case add(Exp, Exp)
//  indirect case mul(Exp, Exp)
//  indirect case mod(Exp, Exp)
//  indirect case div(Exp, Exp)
//  case constant(Int)
//  case digit(Int)
//}
//var rs = [ "x": Exp.constant(0),
//           "y": Exp.constant(0),
//           "z": Exp.constant(0) ]
//
//var dnum = 0
//for l in lines().map({ $0.split().map({ String($0) })}) {
//  switch l[0] {
//  case "inp":
//    assert(l[1] == "w")
//    dnum += 1
//  case "add":
//    var v2 = Exp.constant(0)
//    if let i = Int(l[2]) {
//      v2 = Exp.constant(i)
//    } else {
//      v2 = l[2] == "w" ? .digit(dnum) : rs[l[2]]!
//    }
//    if case let .constant(i1) = rs[l[1]]!, case let .constant(i2) = v2 {
//      rs[l[1]] = .constant(i1 + i2)
//    } else {
//      rs[l[1]] = .add(rs[l[1]]!, v2)
//    }      
//  case "mul":
//    var v2 = Exp.constant(0)
//    if let i = Int(l[2]) {
//      v2 = Exp.constant(i)
//    } else {
//      v2 = l[2] == "w" ? .digit(dnum) : rs[l[2]]!
//    }
//    if case let .constant(i1) = rs[l[1]]!, case let .constant(i2) = v2 {
//      rs[l[1]] = .constant(i1 * i2)
//    } else {
//      if case let .constant(i1) = rs[l[1]]! {
//        switch i1 {
//        case 0:
//          rs[l[1]] = .constant(0)
//        case 1:
//          rs[l[1]] = v2
//        default:
//          rs[l[1]] = .mul(rs[l[1]]!, v2)
//        }
//      } else if case let .constant(i2) = v2 {
//        switch i2 {
//        case 0:
//          rs[l[1]] = .constant(0)
//        case 1:
//          break
//        default:
//          rs[l[1]] = .mul(rs[l[1]]!, v2)
//        }
//      } else {
//        rs[l[1]] = .mul(rs[l[1]]!, v2)
//      }
//    }      
//  case "div":
//    var v2 = Exp.constant(0)
//    if let i = Int(l[2]) {
//      v2 = Exp.constant(i)
//    } else {
//      v2 = l[2] == "w" ? .digit(dnum) : rs[l[2]]!
//    }
//    if case let .constant(i1) = rs[l[1]]!, case let .constant(i2) = v2 {
//      rs[l[1]] = .constant(i1 / i2)
//    } else {
//      if case let .constant(i1) = rs[l[1]]! {
//        switch i1 {
//        case 0:
//          rs[l[1]] = .constant(0)
//        case 1:
//          rs[l[1]] = v2
//        default:
//          rs[l[1]] = .div(rs[l[1]]!, v2)
//        }
//      } else if case let .constant(i2) = v2 {
//        switch i2 {
//        case 0:
//          assert(false)
//          break
//        case 1:
//          break
//        default:
//          rs[l[1]] = .div(rs[l[1]]!, v2)
//        }
//      } else {
//        rs[l[1]] = .div(rs[l[1]]!, v2)
//      }
//    }      
//  case "mod":
//    var v2 = Exp.constant(0)
//    if let i = Int(l[2]) {
//      v2 = Exp.constant(i)
//    } else {
//      v2 = l[2] == "w" ? .digit(dnum) : rs[l[2]]!
//    }
//    if case let .constant(i1) = rs[l[1]]!, case let .constant(i2) = v2 {
//      rs[l[1]] = .constant(i1 % i2)
//    } else {
//      rs[l[1]] = .mod(rs[l[1]]!, v2)
//    }
//  case "eql":
//    break 
//  default:
//    assert(false)
//  }
//}

let As = [  1,  1,  1,  1, 26, 26,  1, 26,  1, 26,  1, 26, 26, 26] 
let Bs = [ 13, 13, 10, 15, -8, -10,11, -3, 14, -4, 14, -5, -8, -11 ]
let Cs = [ 15, 16,  4, 14,  1,  5,  1,  3,  3,  7,  5, 13,  3, 10 ]

func nextZ(z: Int, d: Int, a: Int, b: Int, c: Int) -> Int {
  let x = z % 26 + b
  var z = z
  z /= a
  if d != x {
    z = z * 26 + d + c
  }
  return z
}

var zs = [Int:Int]() // highest digits for a given z
zs[0] = 0
for i in 0..<14 {
  var nextZs = [Int:Int]()
  for d in 1...9 {
    for (z, best) in zs {
      let nz = nextZ(z: z, d: d, a: As[i], b: Bs[i], c: Cs[i])
      nextZs[nz] = min(best * 10 + d, nextZs[nz] ?? Int.max)
    }
  }
  zs = nextZs
  print(i, zs.count)
}

print(zs[0])