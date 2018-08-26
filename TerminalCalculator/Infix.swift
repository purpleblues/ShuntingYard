//
//  Infix.swift
//  TerminalCalculator
//
//  Created by Purple on 26/08/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation


func infixTokenize(_ string: String) throws -> [InfixToken] {
    
    var onFloatingPoint = false
    var lastString = ""
    
    return try string
        .lazy
        .filter { $0.isWhitespace == false }
        .map(String.init)
        .reduce(into: [InfixToken]()) { tokens, string in
            
            defer { lastString = string }
            
            if string == "." {
                
                guard onFloatingPoint == false else {
                    throw "Invalid expression"
                }
                guard lastString != "." else {
                    throw "Invalid expression"
                }
                
                if let top = tokens.last {
                    
                    switch top {
                    case .rightParen:
                        throw "Invalid expression"
                    default:
                        break
                    }
                }
                
                onFloatingPoint = true
                
            } else if let value = Double(string) {
                
                if case let .number(oldValue)? = tokens.last {
                    
                    _ = tokens.popLast()
                    
                    if onFloatingPoint {
                        tokens.append(.number(oldValue + value * (1 / 10.0)))
                    } else {
                        tokens.append(.number(oldValue * 10 + value))
                    }
                    
                } else {
                    if onFloatingPoint {
                        tokens.append(.number(value * (1 / 10.0)))
                    } else {
                        tokens.append(.number(value))
                    }
                    
                }
                
            } else if let `operator` = Operator(rawValue: string) {
                onFloatingPoint = false
                tokens.append(.operator(`operator`))
            } else if string == "(" {
                onFloatingPoint = false
                tokens.append(.leftParen)
            } else if string == ")" {
                onFloatingPoint = false
                tokens.append(.rightParen)
            } else {
                //throw "Invalid Token \(string)"
            }
    }
    
}


func evaluateInfixExpression(_ expression: [InfixToken]) throws -> Double {
    
    var operatorStack = Stack<InfixToken>()
    
    var outputQueue = Queue<PostfixToken>()
    
    for token in expression {
        
        switch token {
        case .dot:
            fatalError()
        case let .number(number):
            outputQueue.enqueue(.number(number))
        case .operator:
            
            switch operatorStack.top {
            case .none:
                operatorStack.push(token)
            case let .some(top):
                switch top {
                case ..<token:
                    operatorStack.push(token)
                case token...:
                    while let top = operatorStack.top, top >= token {
                        _ = operatorStack.pop()
                        
                        outputQueue.enqueue(top.forceAsPostfixOperator)
                    }
                    
                    operatorStack.push(token)
                default:
                    fatalError()
                }
            }
        case .leftParen:
            operatorStack.push(token)
        case .rightParen:
            
            while true {
                if let top = operatorStack.pop() {
                    if top == .leftParen {
                        break
                    } else {
                        outputQueue.enqueue(top.forceAsPostfixOperator)
                    }
                } else {
                    throw "Invalid expression; Unmatching parenthesis"
                }
            }
        }
    }
    
    while let top = operatorStack.pop() {
        switch top {
        case let .operator(`operator`):
            outputQueue.enqueue(.operator(`operator`))
        default:
            fatalError()
        }
    }
    
    return try evaluatePostfixExpression(IteratorSequence(outputQueue))
}
