import Foundation

public enum MyError: Error {
    case runtimeError(String)
}

public let oops = MyError.runtimeError("oops")
