//
//  NSAttributedString.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension String {
    var attribute: NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension NSAttributedString {

    var range: NSRange {
        get {
            return (self.string as NSString).range(of: self.string)
        }
    }
    
    public func font(_ font: UIFont?) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        copy.addAttributes([.font: font ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }
    
    
    public func bold() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }
    
    public func underline(_ strikeThroughStyle: NSUnderlineStyle) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.underlineStyle: strikeThroughStyle.rawValue], range: range)
        return copy
    }
    
    public func italic() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }
    
    public func strikethrough(_ strikeThroughStyle: NSUnderlineStyle) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.strikethroughStyle: strikeThroughStyle.rawValue], range: range)
        return copy
    }
    
    public func foreground(_ color: UIColor) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.foregroundColor: color], range: range)
        return copy
    }
    
    public func background(_ color: UIColor) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        copy.addAttributes([.backgroundColor: color], range: range)
        return copy
    }
}

public func += (left: inout NSAttributedString, right: NSAttributedString) {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.append(right)
    left = ns
}

public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.append(right)
    return ns
}
