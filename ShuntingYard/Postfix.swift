//
//  PostfixEvaluator.swift
//  ShuntingYard
//
//  Created by Purple on 25/08/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation

func postfixTokenize(_ string: String) -> [PostfixToken] {
    
    return string
        .lazy
        .split(omittingEmptySubsequences: true, whereSeparator: { $0.isWhitespace })
        .map { String.init($0) }
        .compactMap {
            
            if let value = Double($0) {
                return .number(value)
            } else if let `operator` = Operator(rawValue: $0) {
                return .operator(`operator`)
            } else {
                return nil
               // throw "Invalid token \($0)"
            }
    }
}

func evaluatePostfixExpression<S: Sequence>(_ expression: S) throws -> Double where S.Element == PostfixToken{
    
    var stack = Stack<Double>()
    
    for token in expression {
        
        switch token {
        case let .number(number):
            stack.push(number)
        case let .operator(`operator`):
            
            guard let rhs = stack.pop() else {
                throw "Invalid expression"
            }
            
            guard let lhs = stack.pop() else {
                throw "Invalid expression"
            }
            
            let result = `operator`.apply(lhs: lhs, rhs: rhs)
            
            stack.push(result)
            
        }
    }
    
    guard stack.count == 1 else {
        throw "Invalid expression"
    }
    
    guard let top = stack.pop() else {
        throw "Invalid epxression"
    }
    
    return top
}


