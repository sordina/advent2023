
import Foundation
import RegexBuilder

// Part 1

func solve(_ text: String) throws -> Int {
    let lines = text.components(separatedBy: "\n").filter { $0.count > 1 }
    let regex = /\d/
    var result = 0
    
    for l in lines {
        guard let m1 = try? regex.firstMatch(in: l),
              let m2 = try? regex.firstMatch(in: String(l.reversed())),
              let mi = Int("\(m1.output)\(m2.output)")
              else { continue }
        
        print(mi)

        result += mi
    }
    
    return result
}

// Test Data
if let u = Bundle.main.url(forResource: "test", withExtension: "data"),
   let c = try? String(contentsOf: u) {
   let answer = try solve(c)
   assert(answer == 142)
}

// Real Data
if let u = Bundle.main.url(forResource: "day_01_input", withExtension: "data"),
   let c = try? String(contentsOf: u) {
    try solve(c)
}

let words: [String] = ["one","two","three","four","five","six","seven","eight","nine"]
let digit: [String] = ["\\d"]

func cast2(_ text: String) throws -> String {
    if let i = words.firstIndex(of: text) {
        return "\(i + 1)"
    } else {
        return text
    }
}

func solve2(_ text: String) throws -> Int {
    let lines = text.components(separatedBy: "\n").filter { $0.count > 1 }
    let forward = words + digit
    let backward = words.map {String($0.reversed())} + digit
    let regex1 = try Regex(forward.joined(separator: "|"))
    let regex2 = try Regex(backward.joined(separator: "|"))
    
    var result = 0
    
    for l in lines {
        guard let m1 = try? regex1.firstMatch(in: l)?.0,
              let m2 = try? regex2.firstMatch(in: String(l.reversed()))?.0,
              let m1s = try? cast2(String(m1)),
              let m2s = try? cast2(String(m2.reversed())),
              let mi = Int("\(m1s)\(m2s)")
              else { continue }
        
        result += mi
    }
    
    return result
    
}

// Real Data
if let u = Bundle.main.url(forResource: "day_01_input", withExtension: "data"),
   let c = try? String(contentsOf: u) {
    try solve2(c)
}
