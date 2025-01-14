//
//  AGObject+Helper.swift
//  BaseProject
//
//  Created by AshvinGudaliya on 19/02/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit
import SwiftyJSON

extension AGObject {

    public func getArray<T>(_ value: Any) -> [T] {
        if let arr = value as? [T] {
            return arr
        }
        return JSON(value).arrayObject as? [T] ?? []
    }
}

public func <= <T: AGObject>(left: inout T, right: [String: AnyObject])  {
    left = T(with: right)
}

public func <= <T: AGObject>(left: inout T, right: [String: AnyObject]?)  {
    if let dictArr = right{
        left <= dictArr
    }
}

public func <= <T: AGObject>(left: inout [T], right: [[String: AnyObject]]?)  {
    if let dictArr = right {
        left <= dictArr
    }
}

public func <= <T: AGObject>(left: inout [T], right: [[String: AnyObject]])  {
    left.removeAll()
    left = right.map {
        T(with: $0)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: AnyObject {
    func convert<T: AGObject>(with: T) -> T{
        return T(with: self as! [String: AnyObject])
    }
}

public extension Mirror {
    public func proparty() -> [String]{
        return self.children.map {
            $0.label!
        }
    }
}

extension String {
    var realType: String {
        return self.removeStrings(array: ["Array", "ImplicitlyUnwrappedOptional", "<", ">", "Optional"])
    }
    
    func removeStrings(array: [String]) -> String {
        var result = self
        for str in array {
            result = result.replacingOccurrences(of: str, with: "")
        }
        return result
    }
}

extension AGObject {
    func classWith(className: String) -> AGObject.Type? {
        if let cls = NSClassFromString(className) as? AGObject.Type {
            return cls
        }
        
        if var bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            bundleName = bundleName.replacingOccurrences(of: ".", with: " ")
            
            let clsName = bundleName + "." + className
            if let cls = NSClassFromString(clsName) as? AGObject.Type {
                return cls
            }
        }
        return nil
    }
}
