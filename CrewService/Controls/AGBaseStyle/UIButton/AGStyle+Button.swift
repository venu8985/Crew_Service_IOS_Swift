//
//  AGStyle+Button.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: AGButton {
    @discardableResult
    func circle() -> Self{
        self.base.isCircle = true
        return self
    }
}

extension AGStyle where Base: UIButton {
    
    @discardableResult
    func title(_ text: AGString, _ state: UIControl.State = .normal) -> Self{
        self.base.setTitle(text.local, for: state)
        return self
    }
    
    @discardableResult
    func title(_ text: String, _ state: UIControl.State = .normal) -> Self{
        self.base.setTitle(text, for: state)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage, _ state: UIControl.State = .normal) -> Self{
        self.base.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func image(_ image: AGImage, _ state: UIControl.State = .normal) -> Self{
        self.base.setImage(image.img, for: state)
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self{
        self.base.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func poppinsFont(size: CGFloat, weight: Poppins) -> Self{
        self.base.titleLabel?.font = UIFont.poppinsFont(size: size, weight: weight)
        return self
    }
    
    @discardableResult
    func latoFont(size: CGFloat, weight: Lato) -> Self{
        self.base.titleLabel?.font = UIFont.latoFont(size: size, weight: weight)
        return self
    }
    
    @discardableResult
    func contentEdgeInsets(_ insets: UIEdgeInsets) -> Self{
        self.base.contentEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func titleEdgeInsets(_ insets: UIEdgeInsets) -> Self{
        self.base.titleEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self{
        self.base.imageEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self{
        self.base.tintColor = color
        return self
    }
    
    @discardableResult
    func attributedText(_ newValue: NSAttributedString, state: UIControl.State = .normal) -> Self {
        base.setAttributedTitle(newValue, for: state)
        return self
    }
}
