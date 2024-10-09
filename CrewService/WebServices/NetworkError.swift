//
//  NetworkError.swift
//  Dumps
//
//  Created by Ashvin Gudaliya on 05/09/20.
//  Copyright © 2020 Nirav. All rights reserved.
//

import UIKit

protocol DumpsLocalizedError: LocalizedError {
    var title: String { get }
    var localDescription: String { get } //useful in local parsing errors during debugging as their errorDescription would show generic message in the popup
}

extension DumpsLocalizedError {
    var title: String {
        return ""
    }
    var localDescription : String {
        return ""
    }
}

enum NetworkError: DumpsLocalizedError {
    
    case errorString(String)
    case generic
    case networkUnreachable
    
     var errorDescription: String? {
        switch self {
        case .errorString(let errorMessage): return errorMessage
        case .generic: return "Something went wrong. Please try again."
        case .networkUnreachable: return "No internet connection. Please try again later."
        }
    }
    
    var info: (code: Double?, message: String) {
        switch self {
        case .errorString(let errorMessage): return (nil, errorMessage)
        case .generic: return  (nil, "Something went wrong. Please try again.")
        case .networkUnreachable: return (1000, "No internet connection. Please try again later.")
        }
    }
    
    var title: String {
        return "Sorry"
    }
}
