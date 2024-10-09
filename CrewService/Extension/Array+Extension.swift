//
//  NSArray.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/5/17.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

public extension Array where Element: Equatable {
    
    // remove duplicate element
    public mutating func removeDuplicates() {

        self = self.reduce([]) {
            $0.contains($1) ? $0 : $0 + [$1]
        }
    }
}

public extension Array {
    
    // Remove Specific object from Array
    public mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if let i = index {
            self.remove(at: i)
        }
    }
    
    //  Chack Array contain specific object
    public func containsObject<T:AnyObject>(item:T) -> Bool{
        for element in self{
            if item === element as? T {
                return true
            }
        }
        return false
    }
    
    //  Get Index of specific object
    public func indexOfObject<T : Equatable>(x: T) -> Int? {
        for i in 0...self.count {
            if let new = self.object(i) as? T {
                if new == x {
                    return i
                }
            }
        }
        return nil
    }
    
    public func find(_ includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
    
    /// Find the element at the specific index
    /// No need to use this to find the first element, just use `aArray.first`
    public func object(_ atIndex: Int) -> Element? {
        
        guard atIndex >= 0 else { return nil }
        
        guard atIndex < count else { return nil }
        
        return self[atIndex]
    }
    
    static func toJSON() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions())
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    //Move object from an index to another
    mutating func moveObject(from: Int, toIndex to: Int) {
        if to != from {
            let obj: Element = self.object(from)!
            self.remove(at: from)
            
            if to >= self.count {
                self.append(obj)
            } else {
                self.insert(obj, at: to)
            }
        }
    }
    
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
}

public extension Array {
    
    public mutating func append(_ newElements: [Element]) {
        self = self + newElements
        //        newElements.forEach() { append($0) }
    }
}

public extension Sequence where Iterator.Element: Hashable {
    
    public var unique: [Iterator.Element] {
        return Array(Set(self))
    }
}

