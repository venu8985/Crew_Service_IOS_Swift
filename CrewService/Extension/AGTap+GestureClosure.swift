//
//  BlockLongPress.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

open class AGTapGestureClosure: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((UITapGestureRecognizer) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        self.numberOfTouchesRequired = fingerCount
        self.tapAction = action
        self.addTarget(self, action: #selector(didTap(_:)))
    }
    
    @objc open func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }
}

extension UIView {
    
    @discardableResult
    func tapped(callback: @escaping ((UITapGestureRecognizer) -> Void)) -> AGTapGestureClosure {
        self.isUserInteractionEnabled = true
        let tapped = AGTapGestureClosure(action: callback)
        self.addGestureRecognizer(tapped)
        return tapped
    }
}
