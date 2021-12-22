import aoclib

struct Pt3: Hashable {
  var x: Int, y: Int, z: Int
}

var on = Set<Pt3>()
for l in lines().map { $0.split() } {
  let turnon = (l[0] == "on")
  let nums = l[1].split(separator: ",").map {
                $0.slice(2).split("..").map { Int($0)! } }
  if turnon {
    let sx = max(-50, nums[0][0]), fx = min(50, nums[0][1])
    if sx <= fx {
      for x in sx...fx {
        let sy = max(-50, nums[1][0]), fy = min(50, nums[1][1])
        if sy <= fy {
          for y in sy...fy {
            let sz = max(-50, nums[2][0]), fz = min(50, nums[2][1])
            if sz <= fz {
              for z in sz...fz {
                on.insert(Pt3(x: x, y: y, z: z))
              }
            }
          }
        }
      }
    }
  } else {
    let sx = max(-50, nums[0][0]), fx = min(50, nums[0][1])
    if sx <= fx {
      for x in sx...fx {
        let sy = max(-50, nums[1][0]), fy = min(50, nums[1][1])
        if sy <= fy {
          for y in sy...fy {
            let sz = max(-50, nums[2][0]), fz = min(50, nums[2][1])
            if sz <= fz {
              for z in sz...fz {
                on.remove(Pt3(x: x, y: y, z: z))
              }
            }
          }
        }
      }
    }
  }
  print(on.count)
}

var out = 0
for x in -50...50 {
  for y in -50...50 {
    for z in -50...50 {
      if on.contains(Pt3(x: x, y: y, z: z)) {
        out += 1
      }
    }
  }
}
print()
print(out)