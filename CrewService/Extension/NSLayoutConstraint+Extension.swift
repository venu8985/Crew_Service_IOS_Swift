//
//  NSLayoutConstraint+Extension.swift
//  Alfayda
//
//  Created by Wholly-iOS on 23/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    public func setActive() {
        self.isActive = true
    }
    
    public func setInactive() {
        self.isActive = false
    }
}
