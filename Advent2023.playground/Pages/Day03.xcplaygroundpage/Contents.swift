
import Foundation

let example_input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

struct Location: Hashable {
    var x: Int
    var y: Int
}

func parse_input(_ s: String) throws -> ([Location : Character], [Location : String]) {
    var grid: [Location : Character] = [:]
    var numbers: [Location : String] = [:]
    for (y, line) in s.components(separatedBy: "\n").enumerated() {
        for m in line.matches(of: /\d+/) {
            let x: Int = line.distance(from: line.startIndex, to: m.startIndex)
            numbers[Location(x: x, y: y)] = String(m.0)
        }
        for (x, c) in line.enumerated() {
            grid[Location(x: x, y: y)] = c
        }
    }
    return (grid, numbers)
}

func is_symbol(_ c: Character) -> Bool {
    return String(c).firstMatch(of: /\d|\.|[0-9]/) == nil
}

func valid(_ grid: [Location : Character], _ l: Location, _ v: String) -> Bool {
    let c = v.count
    for y in (l.y - 1) ... (l.y + 1) {
        for x in (l.x - 1) ... (l.x + c) {
            if let s = grid[Location(x: x, y: y)],
               is_symbol(s) {
                return true
            }
        }
    }
    return false
}

func solve(_ s: String) throws -> Int {
    let (grid, numbers) = try parse_input(s)
    var result = 0
    for (l, v) in numbers {
        if valid(grid, l, v),
           let vi = Int(v) {
            result += vi
        }
    }
    return result
}

// Test input
let test_answer = try solve(example_input)
assert(test_answer == 4361)

if let u = Bundle.main.url(forResource: "day_03_input", withExtension: "data"),
   let c = try? String(contentsOf: u),
   let sum = try? solve(c) {
    
    print(sum)
}


// Part Two

func numbers_around(_ grid: [Location : Character], _ l: Location) -> Set<Location> {
    var locations: Set<Location> = []
    for y in (l.y - 1) ... (l.y + 1) {
        for x in (l.x - 1) ... (l.x + 1) {
            if let n = grid[Location(x: x, y: y)],
               n.isNumber {
                var x_ = x
                while grid[Location(x: x_, y: y)]?.isNumber ?? false {
                    x_ -= 1
                }
                locations.insert(Location(x: x_ + 1, y: y))
            }
        }
    }
    return locations
}

func solve_2(_ s: String) throws -> Int {
    var output = 0
    let parsed = try parse_input(s)
    for (l, c) in parsed.0 {
        if c == "*" {
            let numbers = Array(numbers_around(parsed.0, l))
            if numbers.count == 2,
               let n1s = parsed.1[numbers[0]],
               let n1 = Int(n1s),
               let n2s = parsed.1[numbers[1]],
               let n2 = Int(n2s) {
                output += n1 * n2
            }
        }
    }
    return output
}

// Test part 2
let test_answer_2 = try solve_2(example_input)
assert(test_answer_2 == 467835)

if let u = Bundle.main.url(forResource: "day_03_input", withExtension: "data"),
   let c = try? String(contentsOf: u),
   let sum = try? solve_2(c) {
    
    print(sum)
}
