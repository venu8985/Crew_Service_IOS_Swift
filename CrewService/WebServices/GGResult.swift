//
//  AGResult.swift
//  BaseProject
//
//  Created by AshvinGudaliya on 28/06/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit

public enum GGResult {
    
    case success(AnyObject, GGWebError)
    case failer(GGWebError)
    
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failer: return false
        }
    }
    
    var value: AnyObject? {
        switch self {
        case .success(let v): return v.0
        case .failer: return nil
        }
    }
    
    var ggWebError: GGWebError {
        switch self {
        case .success(let v): return v.1
        case .failer(let e): return e
        }
    }
    
    var message: String {
        switch self {
        case .success(let v): return v.1.alertMessage
        case .failer(let e): return e.alertMessage
        }
    }
}
