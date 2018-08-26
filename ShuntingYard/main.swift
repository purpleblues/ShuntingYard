//
//  main.swift
//  ShuntingYard
//
//  Created by Purple on 15/07/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation

extension String: Error {
    
}

func prompt(message: String) -> String? {
    print(message, terminator: "")
    return readLine(strippingNewline: true)
}


//var calculator = Calculator()

while let input = prompt(message: "Enter: "), input.count > 0 {
    do {
        let tokens = try infixTokenize(input)
        
//        print(tokens)
            //Queue(try postfixTokenize(input))
        
        let result = try evaluateInfixExpression(tokens)
//            //try evaluatePostfixExpression(&queue)
//
        print("Result: \(String(describing: result))")
    } catch {
        print("\(error)")
    }
    
}
