//
//  UIColor+Extension.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit

public extension UIColor {
    

    static let appRed = UIColor(hex: 0xD70225)
    static let appRedBG = UIColor(hex: 0xFBE6EA)
    static let appGreen = UIColor(hex: 0x07A561)
    static let appYellow = UIColor(hex: 0xFACA55)
    static let appBlack = UIColor(hex: 0x000000)
    static let appGray = UIColor(hex: 0xEBEBEC)
    static let appDark = UIColor(hex: 0x171D2A)
    static let appOffGray = UIColor(hex: 0x666666)
    static let appOffWhite = UIColor(hex: 0xF4F4F8)
    
    struct Friend {
        static let title = UIColor(hex: 0x262627)
        static let description = UIColor(hex: 0xa3a3a3)
    }

    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
           let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           let scanner = Scanner(string: hexString)
           if (hexString.hasPrefix("#")) {
               scanner.scanLocation = 1
           }
           var color: UInt32 = 0
           scanner.scanHexInt32(&color)
           let mask = 0x000000FF
           let r = Int(color >> 16) & mask
           let g = Int(color >> 8) & mask
           let b = Int(color) & mask
           let red   = CGFloat(r) / 255.0
           let green = CGFloat(g) / 255.0
           let blue  = CGFloat(b) / 255.0
           self.init(red:red, green:green, blue:blue, alpha:alpha)
       }
}


