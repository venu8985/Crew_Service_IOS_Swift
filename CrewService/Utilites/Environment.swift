//
//  Environment.swift
//  BaseProject
//
//  Created by Wholly-iOS on 17/07/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit

struct Environment {
    
    private static let production: Bool = {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }()
    
    static var isProduction: Bool {
        return self.production
    }
    
    static var isDebug: Bool {
        return !self.production
    }
    
    static var isApiLog: Bool = true
    static var isAGObjectLog: Bool = true
    
    static var isDeveloping: Bool = {
        if Environment.production {
            return false
        }
        if Environment.isSimulator {
            return true
        }
        return false
    }()
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
