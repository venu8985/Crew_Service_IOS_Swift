//
//  CustomImageView.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: AGView {
    func circle() -> Self{
        self.base.isCircle = true
        return self
    }
}

extension AGStyle where Base: UIView {
    
    @discardableResult
    func bgColor(_ color: UIColor) -> Self{
        self.base.backgroundColor = color
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self{
        self.base.tintColor = color
        return self
    }
    
    @discardableResult
    func isUserInteraction(enabled: Bool) -> Self{
        self.base.isUserInteractionEnabled = enabled
        return self
    }
    
    @discardableResult
    func isHidden(_ newValue: Bool) -> Self{
        self.base.isHidden = newValue
        return self
    }
    
    @discardableResult
    func shadow(_ color: UIColor, _ radius: CGFloat, _ offset: CGSize, _ opacity: Float) -> Self{
        shadowColor(color).shadowRadius(radius).shadowOffset(offset).shadowOpacity(opacity)
        return self
    }
    
    @discardableResult
    func cornerRadius(_ newValue: CGFloat) -> Self {
        base.layer.masksToBounds = false
        base.layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        return self
    }
    
    @discardableResult
    func borderColor(_ newValue: UIColor) -> Self {
        base.layer.borderColor = newValue.cgColor
        return self
    }
    
    @discardableResult
    func borderWidth(_ newValue: CGFloat) -> Self {
        base.layer.borderWidth = newValue
        return self
    }
    
    @discardableResult
    func shadowColor(_ newValue: UIColor) -> Self {
        base.layer.shadowColor = newValue.cgColor
        return self
    }
    
    @discardableResult
    func shadowOffset(_ newValue: CGSize) -> Self {
        base.layer.shadowOffset = newValue
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ newValue: Float) -> Self {
        base.layer.shadowOpacity = newValue
        return self
    }
    
    @discardableResult
    func shadowRadius(_ newValue: CGFloat) -> Self {
        base.layer.shadowRadius = newValue
        return self
    }
    
    @discardableResult
    func opacity(_ newValue: Float) -> Self {
        base.layer.opacity = newValue
        return self
    }
    
    @discardableResult
    func isOpaque(_ newValue: Bool) -> Self {
        base.layer.isOpaque = newValue
        return self
    }
}
