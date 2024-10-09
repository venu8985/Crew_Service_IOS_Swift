//
//  Log+Debug.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/6/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import Foundation
import UIKit

struct GGLog {

    static func debug(_ message: String?, filename: NSString = #file, function: String = #function, line: Int = #line) {
        if Environment.isDebug, let s = message {
            print("[\(filename.lastPathComponent)][\(line)][\(function)] - \(s)")
        }
        else{
            print("[\(filename.lastPathComponent)][\(line)][\(function)]")
        }
    }
    
    static func debug(_ message: Any..., filename: NSString = #file, function: String = #function, line: Int = #line) {
        if Environment.isDebug {
            print("[\(filename.lastPathComponent)][\(line)][\(function)] - ", terminator: "")
            message.forEach {
                print($0)
            }
        }
    }
}

struct GGApiLog {
    static func debug(_ message: Any..., filename: NSString = #file, function: String = #function, line: Int = #line) {
        if Environment.isApiLog, Environment.isDebug {
            message.forEach {
                print($0)
            }
        }
    }
}

struct GGObjectLog {
    static func debug(_ message: Any..., filename: NSString = #file, function: String = #function, line: Int = #line) {
        if Environment.isApiLog, Environment.isDebug {
            message.forEach {
                print($0)
            }
        }
    }
}
