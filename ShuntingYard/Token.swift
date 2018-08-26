//
//  Token.swift
//  ShuntingYard
//
//  Created by Purple on 15/07/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation

extension Character {
    var isWhitespace: Bool {
        return unicodeScalars.contains { CharacterSet.whitespacesAndNewlines.contains($0) }
    }
}

enum Operator: String, RawRepresentable, CaseIterable, Equatable, Comparable {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divide = "/"
    case modulo = "%"
    
    func apply(lhs: Double, rhs: Double) -> Double {
        switch self {
        case .plus:
            return lhs + rhs
        case .minus:
            return lhs - rhs
        case .multiply:
            return lhs * rhs
        case .divide:
            return lhs / rhs
        case .modulo:
            return lhs.truncatingRemainder(dividingBy: rhs)
        }
    }
    
    private var priority: Int {
        switch self {
            
        case .plus, .minus:
            return 0
        case .multiply, .divide, .modulo:
            return 1
        }
    }
    
    static func < (lhs: Operator, rhs: Operator) -> Bool {
        return lhs.priority < rhs.priority
    }
}

enum PostfixToken {
    case number(Double)
    case `operator`(Operator)
}

enum InfixToken: Equatable, Comparable, CustomStringConvertible {
    case leftParen
    case rightParen
    case number(Double)
    case dot
    case `operator`(Operator)
    
    var forceAsPostfixOperator: PostfixToken! {
        switch self {
        case let .operator(`operator`):
            return .operator(`operator`)
        default:
            fatalError("Unrechable")
        }
    }
    
    private var priority: Int {
        switch self {
        case .dot:
            fatalError()
        case .number:
            return 0
        case .leftParen:
            return 1
        case let .operator(`operator`):
            switch `operator` {
            case .plus, .minus:
                return 2
            case .multiply, .divide, .modulo:
                return 3
            }
        case .rightParen:
            return 4
        }
    }
    
    static func < (lhs: InfixToken, rhs: InfixToken) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    var description: String {
        switch self {
        case .dot:
            fatalError()
        case .leftParen:
            return "("
        case .rightParen:
            return ")"
        case let .operator(`operator`):
            return `operator`.rawValue
        case let .number(number):
            return String(number)
        }
    }
}
