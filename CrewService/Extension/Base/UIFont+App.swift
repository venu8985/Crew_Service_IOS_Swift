//
//  UIFont+Extension.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit

import UIKit

public enum Poppins: String {
    //        case Black
    //        case BlackItalic
    case Bold
    //        case BoldItalic
    //        case ExtraBold
    //        case ExtraBoldItalic
    //        case ExtraLight
    //        case ExtraLightItalic
    case Italic
    //        case Light
    //        case LightItalic
    case Medium
    //        case MediumItalic
    case Regular
    case SemiBold
    //        case SemiBoldItalic
    //        case Thin
    //        case ThinItalic
}

public enum Lato: String {
    //        case Black
    //        case BlackItalic
    case Bold
    //        case BoldItalic
    //        case Hairline
    //        case HairlineItalic
    //        case Heavy
    //        case HeavyItalic
    //        case Italic
    case Light
    //        case LightItalic
    case Medium
    //        case MediumItalic
    case Regular
    case Semibold
    //        case SemiboldItalic
    //        case Thin
    //        case ThinItalic
}

public extension UIFont {
    
    class func latoFont(size: CGFloat, weight: Lato) -> UIFont {
        if let font = UIFont(name: "Lato-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found Lato-\(weight)")
        }
    }
    
    class func poppinsFont(size: CGFloat, weight: Poppins) -> UIFont {
        if let font = UIFont(name: "Poppins-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found Poppins-\(weight)")
        }
    }
}
