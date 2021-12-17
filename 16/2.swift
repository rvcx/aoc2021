import aoclib

var data = "420D610055D273AF1630010092019207300B278BE5932551E703E608400C335003900AF0402905009923003880856201E95C00B60198D400B50034400E20101DC00E10024C00F1003C400B000212697140249D049F0F8952A8C6009780272D5D074B5741F3F37730056C0149658965E9AED7CA8401A5CC45BB801F0999FFFEEE0D67050C010C0036278A62D4D737F359993398027800BECFD8467E3109945C1008210C9C442690A6F719C48A351006E9359C1C5003E739087E80F27EC29A0030322BD2553983D272C67508E5C0804639D4BD004C401B8B918E3600021D1061D47A30053801C89EF2C4CCFF39204C53C212DABED04C015983A9766200ACE7F95C80D802B2F3499E5A700267838803029FC56203A009CE134C773A2D3005A77F4EDC6B401600043A35C56840200F4668A71580043D92D5A02535BAF7F9A89CF97C9F59A4F02C400C249A8CF1A49331004CDA00ACA46517E8732E8D2DB90F3005E92362194EF5E630CA5E5EEAD1803E200CC228E70700010A89D0BE3A08033146164177005A5AEEB1DA463BDC667600189C9F53A6FF6D6677954B27745CA00BCAE53A6EEDC60074C920001B93CFB05140289E8FA4812E071EE447218CBE1AA149008DBA00A497F9486262325FE521898BC9669B382015365715953C5FC01AA8002111721D4221007E13C448BA600B4F77F694CE6C01393519CE474D46009D802C00085C578A71E4001098F518639CC301802B400E7CDDF4B525C8E9CA2188032600E44B8F1094C0198CB16A29180351EA1DC3091F47A5CA0054C4234BDBC2F338A77B84F201232C01700042A0DC7A8A0200CC578B10A65A000601048B24B25C56995A30056C013927D927C91AB43005D127FDC610EF55273F76C96641002A4F0F8C01CCC579A8D68E52587F982996F537D600"

var d = ""
for c in data {
  switch c {
  case "0":
    d += "0000"
  case "1":
    d += "0001"
  case "2":
    d += "0010"
  case "3":
    d += "0011"
  case "4":
    d += "0100"
  case "5":
    d += "0101"
  case "6":
    d += "0110"
  case "7":
    d += "0111"
  case "8":
    d += "1000"
  case "9":
    d += "1001"
  case "A":
    d += "1010"
  case "B":
    d += "1011"
  case "C":
    d += "1100"
  case "D":
    d += "1101"
  case "E":
    d += "1110"
  case "F":
    d += "1111"
  default:
   assert(false)
  }
}

func fromBinary<T: StringProtocol>(_ s: T) -> Int {
  var v = 0
  for c in s {
    v *= 2
    if c == "1" {
      v += 1
    }
  }
  return v
}

var output = 0


func readPacket(_ pos: inout Int) -> Int {
  let version = d.slice(pos, pos + 3)
  output += fromBinary(version)
  pos += 3
  let type = d.slice(pos, pos + 3)
  pos += 3
  var subs = [Int]()
  switch type {
  case "100":
    var vs = ""
    repeat {
      vs += d.slice(pos + 1, pos + 5)
      pos += 5
    } while d[pos - 5] == "1"
    return fromBinary(vs)
  default:
    if d[pos] == "0" {
      let length = d.slice(pos + 1, pos + 16)
      assert(length.count == 15)
      pos += 16
      let stopAt = pos + fromBinary(length)
      while pos < stopAt {
        subs.append(readPacket(&pos))
      }
    } else {
      let subpackets = d.slice(pos + 1, pos + 12)
      assert(subpackets.count == 11)
      pos += 12
      for _ in 0..<fromBinary(subpackets) {
        subs.append(readPacket(&pos))
      }
    }
    switch type {
    case "000":
      return subs.reduce(0, +)
    case "001":
      return subs.reduce(1, *)
    case "010":
      return subs.min()!
    case "011":
      return subs.max()!
    case "101":
      return subs[0] > subs[1] ? 1 : 0
    case "110":
      return subs[0] < subs[1] ? 1 : 0
    case "111":
      return subs[0] == subs[1] ? 1 : 0
    default:
      assert(false)
    }
  }
  assert(false)
  return 0
}

var p = 0
print(readPacket(&p))

print(d.count, p, output)