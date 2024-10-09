//
//  Float+kFormatted.swift
//  Alfayda
//
//  Created by Wholly-iOS on 19/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

extension Int {
    var kFormatted: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(Int(number))"
        }
    }
}

extension String {
    var kFormatted: String {
        return Int(self)?.kFormatted ?? "0"
    }
}

extension Float {
    var kFormatted: String {
        return Int(self).kFormatted
    }
}

extension Double {
    var kFormatted: String {
        return Int(self).kFormatted
    }
}
