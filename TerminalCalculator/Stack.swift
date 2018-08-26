//
//  Stack.swift
//  TerminalCalculator
//
//  Created by Purple on 15/07/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation

struct Stack<Element> {
    
    private var buffer: [Element] = []
    
    var count: Int {
        return self.buffer.count
    }
    
    mutating func push(_ element: Element) {
        self.buffer.append(element)
    }
    
    @discardableResult mutating func pop() -> Element? {
        return self.buffer.popLast()
    }
    
    var top: Element? {
        return self.buffer.last
    }
    
    mutating func removeAll() {
        self.buffer.removeAll()
    }
    
    init() {
        
    }
    
}
