//
//  AGStyle+UIImageView.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: AGImageView {
    @discardableResult
    func circle() -> Self{
        self.base.isCircle = true
        return self
    }
}

extension AGStyle where Base: UIImageView {
    var cornerRadius: CGFloat {
        get {
            return base.layer.cornerRadius
        }
        set {
            base.layer.masksToBounds = true
            base.layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @discardableResult
    func image(_ img: AGImage) -> Self{
        base.image = img.img
        return self
    }
    
    @discardableResult
    func template() -> Self{
        if let i = base.image {
            base.image = i.template
        }
        return self
    }
    
    @discardableResult
    func original() -> Self{
        if let i = base.image {
            base.image = i.original
        }
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self{
        base.contentMode = mode
        return self
    }
}

extension UIImage {
    //UIImage with .alwaysOriginal rendering mode.
    public var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    //UIImage with .alwaysTemplate rendering mode.
    public var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}
