//
//  CustomImageView.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: AGLabel {
    
    @discardableResult
    func circle() -> Self{
        self.base.isCircle = true
        return self
    }
}

extension AGStyle where Base: UILabel {
    
    @discardableResult
    func text(_ text: AGString) -> Self{
        self.base.text = text.local
        return self
    }
    
    @discardableResult
    func text(_ text: String) -> Self{
        self.base.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ newValue: UIColor) -> Self {
        base.textColor = newValue
        return self
    }
    
    @discardableResult
    func font(_ newValue: UIFont) -> Self {
        base.font = newValue
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ newValue: NSLineBreakMode) -> Self {
        base.lineBreakMode = newValue
        return self
    }
    
    @discardableResult
    func textAlignment(_ newValue: NSTextAlignment) -> Self {
        base.textAlignment = newValue
        return self
    }
    
    @discardableResult
    func attributedText(_ newValue: NSAttributedString) -> Self {
        base.attributedText = newValue
        return self
    }
    
    @discardableResult
    func highlightedTextColor(_ newValue: UIColor) -> Self {
        base.highlightedTextColor = newValue
        return self
    }
    
    @discardableResult
    func isHighlighted(_ newValue: Bool) -> Self {
        base.isHighlighted = newValue
        return self
    }
    
    @discardableResult
    func numberOfLines(_ newValue: Int) -> Self {
        base.numberOfLines = newValue
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ newValue: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = newValue
        return self
    }
    
    @discardableResult
    func baselineAdjustment(_ newValue: UIBaselineAdjustment) -> Self {
        base.baselineAdjustment = newValue
        return self
    }
    
    @discardableResult
    func poppinsFont(size: CGFloat, weight: Poppins) -> Self{
        self.base.font = UIFont.poppinsFont(size: size, weight: weight)
        return self
    }
    
    @discardableResult
    func latoFont(size: CGFloat, weight: Lato) -> Self{
        self.base.font = UIFont.latoFont(size: size, weight: weight)
        return self
    }
}

