//
//  HTTPRouter.swift
//  Dumps
//
//  Created by Ashvin Gudaliya on 05/09/20.
//  Copyright © 2020 Nirav. All rights reserved.
//

import UIKit
import Alamofire

enum Encoding {
    case json
    case url
}

protocol HTTPRouter: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var encodingType: Encoding { get }
    var request: URLRequest { get }
}

extension HTTPRouter {
    
    var baseURL: String {
        return "https://development.htf.sa/diva"
    }
    
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        if UserDetails.isUserLogin{
            return HTTPHeaders([
                "Authorization":"Bearer "+UserDetails.shared.authToken,
                "X-Requested-With":"XMLHttpRequest",
                "Content-Type": "application/json",
                "locale":UserDetails.shared.langauge
            ])
        }else{
            return HTTPHeaders([
                "X-Requested-With":"XMLHttpRequest",
                "Content-Type": "application/json",
                "locale":UserDetails.shared.langauge
            ])
        }
    }
    var encodingType: Encoding {
        return .json
    }
    
    var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return urlRequest
    }
}

protocol HTTPUploadRouter: URLConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension HTTPUploadRouter {
    
    var baseURL: String {
        return "https://development.htf.sa/diva"
    }
    
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return urlRequest
    }
}
