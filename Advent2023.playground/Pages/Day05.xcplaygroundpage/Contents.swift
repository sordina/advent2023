
import Foundation

extension Array {
    var tail: ArraySlice<Element> {
        return self[1 ..< self.count]
    }
}

// map format: destination source count
let example_input = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""

func parse_seeds(_ line: String) -> Set<Int> {
    let numbers: [Int] = line.matches(of: /\d+/).map { Int($0.output) ?? 0
    }
    return Set(numbers)
}

func parse_map(_ line: String) throws -> (Int,Int,Int)? {
    let match = try /(\d+)\s+(\d+)\s+(\d+)/.firstMatch(in: line)
    guard let m1 = match?.output.1,
          let m2 = match?.output.2,
          let m3 = match?.output.3,
          let i1 = Int(m1),
          let i2 = Int(m2),
          let i3 = Int(m3)
            
    else {
        print(line)
        return nil
    }
    return (i1, i2, i3)
}

func parse_mapping(_ x: String) throws -> [(Int,Int,Int)] {
    let lines = x.components(separatedBy: "\n")
    let result = try lines.tail.compactMap {
        try parse_map($0)
    }
    return result
}

func solve_map(_ p: [(Int,Int,Int)], _ i: Int) -> Int {
    for (d,s,c) in p {
        let x = i - s
        if i >= s && x <= c {
            return d + x
        }
    }
    return i
}

func solve_maps(_ ps: [[(Int, Int, Int)]], _ i: Int) -> Int {
    return ps.reduce(i) { partialResult, m in
        solve_map(m, partialResult)
    }
}

func solve(_ x: String) throws -> Int {
    let paragraphs = x.components(separatedBy: "\n\n")
    let seeds = parse_seeds(paragraphs.first ?? "")
    let other = paragraphs.tail
    let mappings = try other.map(parse_mapping)
    let result = seeds.map {
        solve_maps(mappings, $0)
    }.min(by: {$0 < $1})
    
    if let result {
        return result
    } else {
        throw MyError.runtimeError("yikes")
    }
}

let example_answer = try solve(example_input)

assert(example_answer == 35)

if let u = Bundle.main.url(forResource: "day_05_input", withExtension: "data"),
   let c = try? String(contentsOf: u) {
    
    let sum = try! solve(c)
    print(sum)
}
