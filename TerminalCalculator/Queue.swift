//
//  Queue.swift
//  TerminalCalculator
//
//  Created by Purple on 25/08/2018.
//  Copyright © 2018 Purple. All rights reserved.
//

import Foundation

struct Queue<Element> {
    
    private var buffer: [Element]
    
    mutating func enqueue(_ element: Element) {
        self.buffer.append(element)
    }
    
    mutating func dequeue() -> Element? {
        return self.buffer.count > 0 ? self.buffer.removeFirst() : nil
    }
    
    var first: Element? {
        return self.buffer.first
    }
    
    init() {
        self.init([])
    }
    
    init<S: Sequence>(_ sequence: S) where S.Element == Element {
        self.buffer = .init(sequence)
    }
}

extension Queue: IteratorProtocol {
    mutating func next() -> Element? {
        return self.dequeue()
    }
}
