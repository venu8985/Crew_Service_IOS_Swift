//
//  UITableView+RefreshControl.swift
//  BaseProject
//
//  Created by GauravkumarGudaliya on 12/02/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UITableView {
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
    
    var pullToRefresh: (RefreshControlAction)? {
        set(newValue) {
            agRefreshControl.removeTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                agRefreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
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
            if let refreshView = backgroundView as? UIRefreshControl {
                return refreshView
            }
            else{
                backgroundView = UIRefreshControl()
                return UIRefreshControl()
            }
        }
    }
    
    func endRefreshing() {
        agRefreshControl.endRefreshing()
    }
    
    func beginRefreshing() {
        agRefreshControl.beginRefreshing()
    }
    
    @objc private func refreshAction(_ refreshControl: UIRefreshControl) {
        if let action = pullToRefresh {
            action(refreshControl)
        }
    }
}
