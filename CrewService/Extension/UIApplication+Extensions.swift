//
//  UIApplication+Extensions.swift
//  Alfayda
//
//  Created by Wholly-iOS on 28/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    static var window: UIWindow? {
        guard let window = (UIApplication.shared.delegate as! AppDelegate).window else {
            (UIApplication.shared.delegate as! AppDelegate).window = UIWindow(frame: UIScreen.main.bounds)
            return (UIApplication.shared.delegate as! AppDelegate).window
        }
        
        return window
    }

    // Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
