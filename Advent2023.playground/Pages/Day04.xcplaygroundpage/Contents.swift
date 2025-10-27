
import Foundation

let example = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

let line_regex: Regex = /Card\s+\d+:\s+(.*)\s+\|\s+(.*)/
let space_regex: Regex = /\s+/
func solve_line(_ line: String) throws -> Int {
    let match = try line_regex.firstMatch(in: line)
    guard let match else {
        return 0
    }
    
    let o = match.output
    
    let left_array = o.1.components(separatedBy: " ")
    let left = Set(left_array.filter { $0.count > 0 })
    
    let right_array = o.2.components(separatedBy: " ")
    let right_filtered = right_array.filter { left.contains($0) }
    let right_count = right_filtered.count
    
    // 2^--count
    if(right_count > 0) {
        return NSDecimalNumber(decimal: pow(Decimal(2.0), right_count - 1)).intValue
    } else {
        return 0
    }
}

func solve(_ x: String) throws -> Int {
    var result = 0
    for line in x.components(separatedBy: "\n") {
        result += try solve_line(line)
    }
    return result
}

let example_solution = try solve(example)
assert(example_solution == 13)

if let u = Bundle.main.url(forResource: "day_04_input", withExtension: "data"),
   let c = try? String(contentsOf: u) {
    
    let sum = try! solve(c)
    print(sum)
}

// Part 2

typealias Tally = Dictionary<Int, Int>

let line_regex_2: Regex = /Card\s+(\d+):\s+(.*)\s+\|\s+(.*)/
func solve_line_2(_ count: Int, _ line: String, _ tallies: inout Tally) throws {
    let match = try line_regex_2.firstMatch(in: line)
    guard let match else { return }
    let o = match.output
    guard let idx = Int(o.1) else { return }
    
    let tally = tallies[idx] ?? 1 // default current tally to 1
    tallies[idx] = tally
    
    let left_array = o.2.components(separatedBy: " ")
    let left = Set(left_array.filter { $0.count > 0 })
    
    let right_array = o.3.components(separatedBy: " ")
    let right_filtered = right_array.filter { left.contains($0) }
    let right_count = right_filtered.count
    
    // Add the number of copies of the current card to each copied card respectively
    for i in (idx + 1 ..< idx + right_count + 1) {
        if i >= count { break }
        tallies[i] = (tallies[i] ?? 1) + tally
    }
}

func solve2(_ x: String) throws -> Int {
    var tallies: Tally = [:]
    var components = x.components(separatedBy: "\n")
    for line in components {
        try solve_line_2(components.count, line, &tallies)
    }

    return tallies.values.reduce(0) { (r,x) in r + x } // counts tallies
}

let example_solution_2 = try solve2(example)
assert(example_solution_2 == 30)

if let u = Bundle.main.url(forResource: "day_04_input", withExtension: "data"),
   let c = try? String(contentsOf: u) {
    
    let sum = try! solve2(c)
    print(sum)
}
