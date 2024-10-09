//
//  AGKeyboardHelper.swift
//  BaseProject
//
//  Created by AshvinGudaliya on 26/07/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit

@objc public enum KeyboardObserverType: Int {
    case willAppear
    case willDisappear
    case didAppear
    case didDisappear
}

/// Protocol `KeyboardHelperDelegate` requires two functions, `keyboardWillAppear`, `keyboardDidAppear`, `keyboardWillDisappear` and `keyboardDidDisappear` with parameter `info` struct `KeyboardAppearanceInfo`.
@objc public protocol KeyboardHelperDelegate: class {
    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard do any changes.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    /// - Parameter action: enum `KeyboardObserverType`.
    @objc optional func keyboardObserver(_ action: KeyboardObserverType, _ info: AGKeyboardAppearanceInfo)
    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will appaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    @objc optional func keyboardWillAppear(_ info: AGKeyboardAppearanceInfo)
    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will disappaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    @objc optional func keyboardWillDisappear(_ info: AGKeyboardAppearanceInfo)
    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard did appaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    @objc optional func keyboardDidAppear(_ info: AGKeyboardAppearanceInfo)
    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard did disappaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    @objc optional func keyboardDidDisappear(_ info: AGKeyboardAppearanceInfo)
}

class AGKeyboardHelper {
    
    /// Delegate that conforms with the `KeyboardHelperDelegate`.
    public weak var delegate: KeyboardHelperDelegate?
    
    public var isKeyboardVisible: Bool = false
    
    /// Initialize the `delegate` and add the two observer for `keyboardWillAppear` and `keyboardWillDisappear`.
    /// Observers are nessecary for tracking the `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification`, so the function that are connectet are getting fired.
    ///
    /// - Parameter delegate: KeyboardHelperDelegate
    required public init(delegate: KeyboardHelperDelegate) {
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(AGKeyboardHelper.keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AGKeyboardHelper.keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AGKeyboardHelper.keyboardDidAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AGKeyboardHelper.keyboardDidDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    /// Making sure that you can't intantiate it without a delegate
    private init() {
        delegate = nil
    }
    
    @objc dynamic private func keyboardWillAppear(_ note: Notification) {
        isKeyboardVisible = true
        let info = AGKeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillAppear?(info)
        self.delegate?.keyboardObserver?(.willAppear, info)
    }
    
    @objc dynamic private func keyboardWillDisappear(_ note: Notification) {
        isKeyboardVisible = false
        let info = AGKeyboardAppearanceInfo(notification: note)
        info.frame = .zero
        self.delegate?.keyboardWillDisappear?(info)
        self.delegate?.keyboardObserver?(.willDisappear, info)
    }
    
    @objc dynamic private func keyboardDidAppear(_ note: Notification) {
        isKeyboardVisible = true
        let info = AGKeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardDidAppear?(info)
        self.delegate?.keyboardObserver?(.didAppear, info)
    }
    
    @objc dynamic private func keyboardDidDisappear(_ note: Notification) {
        isKeyboardVisible = false
        let info = AGKeyboardAppearanceInfo(notification: note)
        info.frame = .zero
        self.delegate?.keyboardDidDisappear?(info)
        self.delegate?.keyboardObserver?(.didDisappear, info)
    }
    
    func unregister() {
        

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        self.unregister()
    }
}
