//
//  main.swift
//  Brainfuck-Interpreter
//
//  Created by Rafael Martins on 11/28/18.
//  Copyright © 2018 snit-ram. All rights reserved.
//

import Foundation

func getch() -> Int {
    var key: Int = 0
    let c: cc_t = 0
    let cct = (c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c) // Set of 20 Special Characters
    var oldt: termios = termios(c_iflag: 0, c_oflag: 0, c_cflag: 0, c_lflag: 0, c_cc: cct, c_ispeed: 0, c_ospeed: 0)
    
    tcgetattr(STDIN_FILENO, &oldt) // 1473
    var newt = oldt
    newt.c_lflag = 1217  // Reset ICANON and Echo off
    tcsetattr( STDIN_FILENO, TCSANOW, &newt)
    key = Int(getchar())  // works like "getch()"
    tcsetattr( STDIN_FILENO, TCSANOW, &oldt)
    return key
}

struct ValueTransferDestination {
    let offset: Int
    var multiplier: Int
}
extension ValueTransferDestination: CustomStringConvertible {
    var description: String {
        return "\(offset):\(multiplier)"
    }
}

enum Expression {
    case left(count: Int)
    case right(count: Int)
    case increment(count: Int)
    case decrement(count: Int)
    case print
    case readChar
    case loop(expressions: [Expression])
    
    // optimizations
    case reset
    case transfer(to: [ValueTransferDestination])
}

extension Expression: CustomStringConvertible {
    public var description: String {
        switch self {
        case .decrement(count: let count):
            return "-\(count)"
        case .increment(count: let count):
            return "+\(count)"
            
        case .left(count: let count):
            return "<\(count)"
        case .right(count: let count):
            return ">\(count)"
            
        case .print:
            return "."
        case .readChar:
            return ","
            
        case .loop(expressions: let expressions):
            return "[" + expressions.map {$0.description}.joined(separator: " ") + "]"
            
        case .transfer(to: let locations):
            return "T(" + locations.map { $0.description }.joined(separator: ", ") + ")"
            
        case .reset:
            return "0"
        }
    }
}

extension Expression {
    init?(character: Character) {
        switch character {
        case ".":
            self = .print
        case ",":
            self = .readChar

        case ">":
            self = .right(count: 1)
        case "<":
            self = .left(count: 1)

        case "+":
            self = .increment(count: 1)
        case "-":
            self = .decrement(count: 1)
        default:
            return nil
        }
    }
}

let maxValue = 32768

class Memory {
    var pointer: Int = 0
    private let entries: NSMutableArray = NSMutableArray(array: Array.init(repeating: 0, count: maxValue))
    var value: Int {
        get {
            return self[pointer]
        }
        set {
            self[pointer] = newValue
        }
    }
    
    subscript(index: Int) -> Int {
        get {
            return (entries[index] as! NSNumber).intValue
        }
        set {
            entries[index] = newValue
        }
    }
}

class Brainfuck {
    let expressions: [Expression]
    let memory = Memory()
    var output: TextOutputStream
    
    init(source: String, output: TextOutputStream) {
        self.output = output
        self.expressions = Brainfuck.optimized(Brainfuck.parse(source: source))
    }
    
    static func loopSource(at externalStartIndex: String.Index, in source: String) -> String {
        let startIndex = source.index(after: externalStartIndex)
        let substring = source[startIndex...]
        var stack: [String.Index] = [externalStartIndex]
        
        for (offset, character) in substring.enumerated() {
            let index = source.index(startIndex, offsetBy: offset)
            if character == "[" {
                stack.append(index)
            }
            if character == "]" {
                _ = stack.popLast()
                if stack.isEmpty {
                    let endIndex = substring.index(before: index)
                    return String(source[substring.startIndex...endIndex])
                }
            }
        }
        
        fatalError("missing ]")
    }
    
    static func parse(source: String) -> [Expression] {
        var result: [Expression] = []
        
        var i = source.startIndex
        
        while i < source.endIndex {
            let character = source[i]
            if let expression = Expression(character: source[i]) {
                result.append(expression)
            } else if character == "[" {
                let loopSource = self.loopSource(at: i, in: source)
                let expression : Expression = .loop(expressions: parse(source: loopSource))
                result.append(expression)
                i = source.index(i, offsetBy: loopSource.count + 1)
            } else if character == "]" {
                fatalError("unexpected ]")
            }
            i = source.index(after: i)
        }
        
        return result
    }
    
    static func optimized(_ expressions: [Expression]) -> [Expression] {
        return optimizeTransfers(optimizeResets(merged(expressions)))
    }
    
    static func optimizeResets(_ expressions: [Expression]) -> [Expression] {
        return expressions.map { expression in
            switch expression {
            case .loop(expressions: let expressions):
                let isReset = expressions.count == 1 && expressions.allSatisfy({
                    switch $0 {
                    case .increment(count: 1),
                         .decrement(count: 1):
                        return true
                    default:
                        return false
                    }
                })
                
                if isReset {
                    return .reset
                }
                
                return .loop(expressions: optimizeResets(expressions))
            default:
                return expression
            }
        }
    }
    
    static func transfer(from expressions: [Expression]) -> Expression? {
        guard !expressions.isEmpty else {
            return nil
        }
        
        var destinations: [Int: ValueTransferDestination] = [:]
        func add(_ count: Int, to offset: Int) {
            let defaultDestination = ValueTransferDestination(
                offset: offset,
                multiplier: 0
            )
            destinations[offset, default: defaultDestination].multiplier += count
        }
        
        var offset = 0
        for expression in expressions {
            switch expression {
            case .increment(count: let count): add(count, to: offset)
            case .decrement(count: let count): add(-count, to: offset)
            case .left(count: let count): offset -= count
            case .right(count: let count): offset += count
            default:
                return nil
            }
        }
        
        // well formed transfers return to initial position
        guard offset == 0,
            let startingPosition = destinations[0],
            // well formed transfers increment or decrement the initial position by 1
            abs(startingPosition.multiplier) == 1 else {
            return nil
        }
        
        return Expression.transfer(to: destinations.values.sorted { $0.offset < $1.offset })
    }
    
    static func optimizeTransfers(_ expressions: [Expression]) -> [Expression] {
        return expressions.map { expression in
            switch expression {
            case .loop(expressions: let innerExpressions):
                if let transfer = self.transfer(from: innerExpressions) {
                    return transfer
                }
                return .loop(expressions: optimizeTransfers(innerExpressions))
            default:
                return expression
            }
        }
    }
    
    static func merged(_ expressions: [Expression]) -> [Expression] {
        return expressions.reduce(into: Array<Expression>(), { (results, expression) in
            switch (results.last, expression) {
            case let (.increment(count: a)?, .increment(count: b)):
                results.removeLast()
                results.append(.increment(count: a + b))
                
            case let (.decrement(count: a)?, .decrement(count: b)):
                results.removeLast()
                results.append(.decrement(count: a + b))
                
            case let (.left(count: a)?, .left(count: b)):
                results.removeLast()
                results.append(.left(count: a + b))
            
            case let (.right(count: a)?, .right(count: b)):
                results.removeLast()
                results.append(.right(count: a + b))
                
            case (_, .loop(expressions: let expressions)):
                results.append(.loop(expressions: merged(expressions)))
                
            default:
                results.append(expression)
            }
        })
    }
    
    func run() {
        expressions.forEach { expression in
            expression.run(program: self)
        }
    }
}

extension Expression {
    func run(program: Brainfuck) {
        switch self {
        case .left(count: let count):
            program.memory.pointer -= count
            
        case .right(count: let count):
            program.memory.pointer += count
            
        case .increment(count: let count):
            program.memory.value += count
            
        case .decrement(count: let count):
            program.memory.value -= count
            
        case .print:
            guard program.memory.value > 0,
                let character = UnicodeScalar(program.memory.value).map(Character.init) else {
                return
            }
            
            program.output.write(String(character))
            
        case .readChar:
            program.memory.value = getch()
            
        case .loop(expressions: let expressions):
            while program.memory.value != 0 {
                expressions.forEach { expression in
                    expression.run(program: program)
                }
            }
            
        case .transfer(to: let destinations):
            let sourceIndex = program.memory.pointer
            let sourceValue = program.memory[sourceIndex]
            
            guard sourceValue != 0 else {
                return
            }
            
            destinations.forEach { destination in
                let index = sourceIndex + destination.offset
                program.memory[index] += sourceValue * destination.multiplier
            }
            
        //optimizations
        case .reset:
            program.memory.value = 0
        }
    }
}

extension Brainfuck: CustomStringConvertible {
    var description: String {
        return expressions.map { $0.description }.joined(separator: " ")
    }
}

class ConsoleStream: TextOutputStream {
    private let fileHandle = FileHandle.standardOutput
    func write(_ string: String) {
        fileHandle.write(string.data(using: .utf8)!)
    }
}

let arguments = CommandLine.arguments[1...]

let directoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)

if let path = arguments.first {
    let sourceURL = URL(fileURLWithPath: path, relativeTo: directoryURL)
    let source = try! String(contentsOf: sourceURL)
    let program = Brainfuck(source: source, output: ConsoleStream())
    program.run()
} else {
    print("usage:")
    print("bf <filename>")
}
