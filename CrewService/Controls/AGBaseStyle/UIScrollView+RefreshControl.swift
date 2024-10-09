//
//  UITableView+RefreshControl.swift
//  BaseProject
//
//  Created by GauravkumarGudaliya on 12/02/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct AssociatedKeys {
        static var ActionKey = "UIRefreshControlActionKey"
    }
    
    private class ActionWrapper {
        let action: RefreshControlAction
        init(action: @escaping RefreshControlAction) {
            self.action = action
        }
    }
    
    typealias RefreshControlAction = ((UIRefreshControl) -> Void)
    
    var pullToRefreshScroll: (RefreshControlAction)? {
        set(newValue) {
            agRefreshControl.tintColor = .black
            agRefreshControl.removeTarget(self, action: #selector(refreshAction1(_:)), for: .valueChanged)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                agRefreshControl.addTarget(self, action: #selector(refreshAction1(_:)), for: .valueChanged)
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    private var agRefreshControl: UIRefreshControl {
        if #available(iOS 10.0, *) {
            if let refreshView = self.refreshControl {
                return refreshView
            }
            else{
                self.refreshControl = UIRefreshControl()
                return self.refreshControl!
            }
        }
        else{
            return UIRefreshControl()
        }
    }
    @objc private func refreshAction1(_ refreshControl: UIRefreshControl) {
        if let action = pullToRefreshScroll {
            action(refreshControl)
        }
    }
}
