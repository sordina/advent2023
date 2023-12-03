
import Foundation

let test_data = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""

let red_constraint = 12
let green_constraint = 13
let blue_constraint = 14

typealias Output = [Int: (Int, Int, Int)]

enum MyError: Error {
    case runtimeError(String)
}

let oops = MyError.runtimeError("oops")

let pair_regex = /(\d+) (.*)/
func parse_set(_ set: String) throws -> Bool {
    for pair_string in set.components(separatedBy: ", ") {
        let pair_match = try? pair_regex.firstMatch(in: pair_string)
        guard
            let count_string = pair_match?.output.1,
            let color = pair_match?.output.2,
            let count = Int(count_string)
            else { throw oops }
        switch color {
        case "red":
            if count > red_constraint {
                return false
            }
        case "green":
            if count > green_constraint {
                return false
            }
        case "blue":
            if count > blue_constraint {
                return false
            }
        default:
            throw oops
        }
    }
    return true
}

let line_regex = /Game (\d+): (.*)/
func parse_line(_ line: String) throws -> Int {
    let match = try line_regex.firstMatch(in: line)
    guard
        let id_string = match?.output.1,
        let id = Int(id_string),
        let cubes_string = match?.output.2
        else { throw oops }
    for set_string in cubes_string.components(separatedBy: "; ") {
        if try !parse_set(set_string) {
            return 0
        }
    }
    
    return id
}

func parse_input(_ lines: String) throws -> Int {
    var output = 0
    for l in lines.components(separatedBy: "\n") {
        do {
            if(l.count > 1) {
                output += try parse_line(l)
            }
        } catch {
            print("error for line \(l)")
        }
    }
    return output
}

try parse_input(test_data)

if let u = Bundle.main.url(forResource: "day_02_input", withExtension: "data"),
   let c = try? String(contentsOf: u),
   let sum = try? parse_input(c) {
    
    print(sum)
}


// Part 2

func parse_set_b(_ set: String) throws -> (Int,Int,Int) {
    var minimums = (0,0,0)
    for pair_string in set.components(separatedBy: ", ") {
        let pair_match = try? pair_regex.firstMatch(in: pair_string)
        guard
            let count_string = pair_match?.output.1,
            let color = pair_match?.output.2,
            let count = Int(count_string)
            else { throw oops }
        switch color {
        case "red":
            minimums.0 = max(count, minimums.0)
        case "green":
            minimums.1 = max(count, minimums.1)
        case "blue":
            minimums.2 = max(count, minimums.2)
        default:
            throw oops
        }
    }
    return minimums
}

func parse_line_b(_ line: String) throws -> Int {
    var minimums = (0,0,0)
    let match = try line_regex.firstMatch(in: line)
    guard
        let cubes_string = match?.output.2
        else { throw oops }
    
    for set_string in cubes_string.components(separatedBy: "; ") {
        let rgb = try parse_set_b(set_string)
        minimums.0 = max(rgb.0, minimums.0)
        minimums.1 = max(rgb.1, minimums.1)
        minimums.2 = max(rgb.2, minimums.2)
    }
    
    return minimums.0 * minimums.1 * minimums.2
}

func parse_input_b(_ lines: String) throws -> Int {
    var output = 0
    for l in lines.components(separatedBy: "\n") {
        do {
            if(l.count > 1) {
                output += try parse_line_b(l)
            }
        } catch {
            print("error for line \(l)")
        }
    }
    return output
}

try parse_input_b(test_data)

if let u = Bundle.main.url(forResource: "day_02_input", withExtension: "data"),
   let c = try? String(contentsOf: u),
   let sum = try? parse_input_b(c) {
    
    print(sum)
}

