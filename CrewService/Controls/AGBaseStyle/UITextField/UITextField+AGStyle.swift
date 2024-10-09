//
//  UITextField+AGStyle.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: AGTextField {
    func placeholderTextColor(_ newValue: UIColor) -> Self {
        base.placeholderTextColor = newValue
        return self
    }
    
    @discardableResult
    func leftImage(_ newValue: AGImage) -> Self {
        base.leftImage = newValue.img
        return self
    }
    
    @discardableResult
    func rightImage( _ newValue: AGImage) -> Self {
        base.rightImage = newValue.img
        return self
    }
    
    @discardableResult
    func leftImage(_ newValue: UIImage) -> Self {
        base.leftImage = newValue
        return self
    }
    
    @discardableResult
    func rightImage( _ newValue: UIImage) -> Self {
        base.rightImage = newValue
        return self
    }
}

extension AGStyle where Base: UITextField {
    
    @discardableResult
    func textColor(_ newValue: UIColor) -> Self {
        base.textColor = newValue
        return self
    }
    
    @discardableResult
    func text(_ newValue: AGString) -> Self {
        base.text = newValue.local
        return self
    }
    
    @discardableResult
    func placeholder(_ newValue: AGString) -> Self {
        base.placeholder = newValue.local
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
    
    @discardableResult
    func textAlignment(_ newValue: NSTextAlignment) -> Self {
        base.textAlignment = newValue
        return self
    }
    
    @discardableResult
    func borderStyle(_ newValue: UITextField.BorderStyle) -> Self {
        base.borderStyle = newValue
        return self
    }
    
    @discardableResult
    func attributedText(_ newValue: NSAttributedString) -> Self {
        base.attributedText = newValue
        return self
    }
}


