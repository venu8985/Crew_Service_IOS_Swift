//
//  NetworkManager.swift
//  Dumps
//
//  Created by Ashvin Gudaliya on 05/09/20.
//  Copyright © 2020 Nirav. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class GGRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401,UserDetails.isUserLogin else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        CommonAPI.shared.refreshtoken(parameters: [:]) { data in
            completion(.retry)
        }
    }
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + UserDetails.shared.authToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
public typealias GGParameters1 = [String: Any]
class GGWebServices1: NSObject{
    
    let interceptor = GGRequestInterceptor()

    let networkUnavailableCode: Double = 1000
    
    typealias ResponseHandler = ((GGResult) -> Void)
    fileprivate var responseHandlerBlock: ResponseHandler?
    
    @discardableResult
    init(postRequest url: GGWebKey, parameters: Parameters) {
        super.init()
        
    }
    
    @discardableResult
    init(putRequest url: GGWebKey, parameters: Parameters) {
        super.init()
    
    }
    
    @discardableResult
    init(getRequest url: GGWebKey, parameters: Parameters) {
        super.init()
    
    }
    
    @discardableResult
    init(deleteRequest url: GGWebKey, parameters: Parameters) {
        super.init()
    
    }
    
    @discardableResult
    init(uploadRequest url: GGWebKey, parameters: Parameters, method: HTTPMethod) {
        super.init()
    
    }
    
    func responseJSON(isShow: Bool = true, responseHandler: @escaping ResponseHandler)->Self{
        return self
    }
    
    func makeRequest(url:GGWebKey,parameters: [String: Any] = [:],method: HTTPMethod = .post, showProgress: Bool = true, completion: @escaping (Result<Any, NetworkError>) -> ()) {
        
       
        if showProgress{
            GGProgress.shared.showProgress()
        }
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        
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
        debugPrint("-------------- Start Request -----------------")
        debugPrint("URL: \(url.relative)")
        if let h = headers{
            debugPrint("headers:",h)
        }
        debugPrint("parameters:",parametersTemp)
        debugPrint("-------------- End Request -----------------")
        AF.request(url.relative, method: method, parameters: parametersTemp,encoding: JSONEncoding.default,headers:headers,interceptor:interceptor).validate()
            .responseJSON { result in
                if let d = result.data, let s = String(data: d, encoding: .utf8) {
                    debugPrint("-------------- Start Response -----------------")
                    debugPrint("URL: \(url.relative)")
                    if let res = result.response{
                        debugPrint("Result:",res)
                    }
                    debugPrint("Response: \(s)")
                    debugPrint("-------------- End Response -----------------")
                }
                switch result.result {
                case .success(let v):
                 
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: v, options: .prettyPrinted)
                        debugPrint(jsonData)
                    } catch _ {
                    }
                    
                    if let r = result.response,  r.statusCode == 403 || r.statusCode == 402{
                        if r.statusCode == 402 || r.statusCode == 403{
                            UserDetails.isUserLogin = false
                            CommonAPI.shared.timer.invalidate()
                            let login = UIStoryboard.instantiateViewController(withViewClass: SplashScreenController.self)
                            let navi = UINavigationController(rootViewController: login)
                            AppDelegate.shared.window?.rootViewController = navi
                            AppDelegate.shared.window?.makeKeyAndVisible()
                        }else{
                            if let error = self.errorMessage(data: result.data) {
                                completion(.failure(NetworkError.errorString(error)))
                            } else {
                                completion(.failure(NetworkError.generic))
                            }
                        }
                    }else if let r = result.response,  r.statusCode == 500{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else if let r = result.response,  r.statusCode == 503{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else{
                        if let error = self.errorMessage(data: result.data) {
                            completion(.failure(NetworkError.errorString(error)))
                        } else {
                            completion(.success(v))
                        }
                    }
                case .failure(let error):
                    if let error = self.errorMessage(data: result.data) {
                        completion(.failure(NetworkError.errorString(error)))
                    } else {
                        completion(.failure(self.generateError(from: error.underlyingError ?? error, with: result)))
                    }
                }
                if showProgress{
                    GGProgress.shared.hideProgress()
                }
            }
    }
    
    func makeRequestCodable<T: Codable>(url:GGWebKey,parameters: [String: Any] = [:],method: HTTPMethod = .post, showProgress: Bool = true, completion: @escaping (Result<T, NetworkError>) -> ()) {
        
        if showProgress {
            GGProgress.shared.showProgress()
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
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        
        debugPrint("-------------- Start Request -----------------")
        debugPrint("URL: \(url.relative)")
        if let h = headers{
            debugPrint("headers:",h)
        }
        debugPrint("parameters:",parametersTemp)
        debugPrint("-------------- End Request -----------------")
        AF.request(url.relative, method: method, parameters: parametersTemp,encoding: JSONEncoding.default,headers:headers,interceptor:interceptor).validate()
            .responseDecodable(completionHandler: { ( result: DataResponse<T, AFError>) in
                if let d = result.data, let s = String(data: d, encoding: .utf8) {
                    debugPrint("-------------- Start Response -----------------")
                    if let res = result.response{
                        debugPrint("Result:",res)
                    }
                    debugPrint("Response: \(s)")
                    debugPrint("-------------- End Response -----------------")
                }
                switch result.result {
                case .success(let v):
                    
                    //debugPrint("Response:",result.response!)
                    if let r = result.response,  r.statusCode == 403 || r.statusCode == 402{
                        if r.statusCode == 402 || r.statusCode == 403{
                            UserDetails.isUserLogin = false
                            let login = UIStoryboard.instantiateViewController(withViewClass: SplashScreenController.self)
                            let navi = UINavigationController(rootViewController: login)
                            AppDelegate.shared.window?.rootViewController = navi
                            AppDelegate.shared.window?.makeKeyAndVisible()
                        }else{
                            if let error = self.errorMessage(data: result.data) {
                                completion(.failure(NetworkError.errorString(error)))
                            } else {
                                completion(.failure(NetworkError.generic))
                            }
                        }
                    }else if let r = result.response,  r.statusCode == 500{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else if let r = result.response,  r.statusCode == 503{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else{
                        completion(.success(v))
                    }
                case .failure(let error):
                    if let error = self.errorMessage(data: result.data) {
                        completion(.failure(NetworkError.errorString(error)))
                    } else {
                        completion(.failure(self.generateError(from: error.underlyingError ?? error, with: result)))
                    }
                }
                if showProgress{
                    GGProgress.shared.hideProgress()
                }
            })
    }
    
    //Request failure errors
     func generateError(from error: Error, with responseObject: AFDataResponse<Any>) -> NetworkError {
        let code = (error as NSError).code
        switch code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost, NSURLErrorTimedOut:
            return NetworkError.networkUnreachable
        default:
            if let data = responseObject.data, let jsonString = String(data: data, encoding: .utf8) {
                #if DEBUG
                return NetworkError.errorString(jsonString)
                #else
                return NetworkError.generic
                #endif
            }
            return NetworkError.generic
        }
    }
    
     func generateError<T: Codable>(from error: Error, with responseObject: AFDataResponse<T>) -> NetworkError {
        let code = (error as NSError).code
        switch code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost, NSURLErrorTimedOut:
            return NetworkError.networkUnreachable
        default:
            if let data = responseObject.data, let jsonString = String(data: data, encoding: .utf8) {
                #if DEBUG
                return NetworkError.errorString(jsonString)
                #else
                return NetworkError.generic
                #endif
            }
            return NetworkError.generic
        }
    }
    
     func errorMessage(data: Data?) -> String? {
        if let data = data, let value = try? JSON(data: data) {
            if let errorMessage = value["errors"].dictionary{
                var errorString: String?
                for (_, value) in errorMessage
                {
                    errorString = value[0].stringValue
                    break
                }
                return errorString
            }
        }
        return nil
    }
}

extension GGWebServices1 {
    //MARK: Alamofire Upload Requests
     func makeUploadRequest(url:GGWebKey,parameters: [String: Any] = [:],method: HTTPMethod = .post, showProgress: Bool = true, completion: @escaping (Result<Any, NetworkError>) -> ())  {
        
        GGProgress.shared.showProgress()
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
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        
        let manager =  Session.default
        manager.session.configuration.timeoutIntervalForRequest = 180
        manager.upload(multipartFormData: { multipartFormData in
            multipartFormData.addVideoParameters(withParam: parametersTemp)
        }, to: url.relative,headers: headers,interceptor:interceptor)
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            //hud.progressObject = progress
        }).validate()
        .responseJSON { result in
            
            switch result.result {
            case .success(let v):
                if let r = result.response,  r.statusCode == 403 || r.statusCode == 402{
                    if r.statusCode == 402 ||  r.statusCode == 403 {
                        UserDetails.isUserLogin = false
                        let login = UIStoryboard.instantiateViewController(withViewClass: SplashScreenController.self)
                        let navi = UINavigationController(rootViewController: login)
                        AppDelegate.shared.window?.rootViewController = navi
                        AppDelegate.shared.window?.makeKeyAndVisible()
                    }else if let r = result.response,  r.statusCode == 500{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else if let r = result.response,  r.statusCode == 503{
                        completion(.failure(NetworkError.errorString((v as? [String:AnyObject] ?? [:])["message"] as? String ?? "")))
                    }else{
                        if let error = self.errorMessage(data: result.data) {
                            completion(.failure(NetworkError.errorString(error)))
                        } else {
                            completion(.failure(NetworkError.generic))
                        }
                    }
                }else{
                    completion(.success(v))
                }
            case .failure(let error):
                if let error = self.errorMessage(data: result.data) {
                    completion(.failure(NetworkError.errorString(error)))
                } else {
                    completion(.failure(self.generateError(from: error.underlyingError ?? error, with: result)))
                }
            }
            GGProgress.shared.hideProgress()
        }
    }
}

extension MultipartFormData {
    
    func addVideoParameters(withParam parameters: [String: Any]?) {
        
        for param in parameters ?? [:] {
            
            if let videoDetails = param.value as? ImageUploadData, videoDetails.data != nil {
                append(videoDetails.data!, withName: videoDetails.key, fileName: videoDetails.fileName, mimeType: videoDetails.type.rawValue)
            }
            
            else if let videoDetails = param.value as? VideoUploadURL, videoDetails.url != nil {
                append(videoDetails.url!, withName: videoDetails.key, fileName: videoDetails.getFileName(), mimeType: videoDetails.getFileExtension().rawValue)
            }
            else {
                append("\(param.value)".data(using: String.Encoding.utf8)!, withName: param.key)
            }
        }
    }
}
