//
//  Array_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// extension for element that is Equatable
extension Array where Element: Equatable {
    
    /// extension method to move an item to a specific index on current Array
    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = index(of: item) {
            move(at: index, to: newIndex)
        }
    }
    
    /// bring a given existing element to index 0 on current Array
    mutating func bringToFront(item: Element) {
        move(item, to: 0)
    }
    
    /// move a given existing element to last index of Array
    mutating func sendToBack(item: Element) {
        move(item, to: endIndex-1)
    }
}

extension Array {
    
    /// moving element at index to another index 
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}
