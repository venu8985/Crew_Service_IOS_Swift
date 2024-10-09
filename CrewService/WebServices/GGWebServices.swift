//
//  BaseWebServices.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/11/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator

public typealias GGParameters = [String: Any]

class GGWebServices: NSObject {
    
    typealias ResponseHandler = ((GGResult) -> Void)
    var TempDataRequest: DataRequest!
    internal var dataRequest: DataRequest!
    fileprivate let sessionManager = Session.default
    fileprivate var responseHandlerBlock: ResponseHandler?
    
    static func configure() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
       
    }
    
    @discardableResult
    init(postRequest url: GGWebKey, parameters: Parameters) {
        super.init()
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        let header = self.getHeader(url)
        GGApiLog.debug("===========Request===========")
        GGApiLog.debug("Url: " + url.relative)
        GGApiLog.debug("Header: " + header.description)
        GGApiLog.debug("Parameter: " + parametersTemp.description)
        GGApiLog.debug("===========Request===========")
        sessionManager.session.configuration.timeoutIntervalForRequest = 20
        dataRequest = sessionManager.request(url.relative, method: .post, parameters: parametersTemp, encoding: JSONEncoding.default, headers: header)
        
    }
    
    @discardableResult
    init(putRequest url: GGWebKey, parameters: Parameters) {
        super.init()
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        let header = self.getHeader(url)
        GGApiLog.debug("===========Request===========")
        GGApiLog.debug("Url: " + url.relative)
        GGApiLog.debug("Header: " + header.description)
        GGApiLog.debug("Parameter: " + parametersTemp.description)
        GGApiLog.debug("===========Request===========")
        sessionManager.session.configuration.timeoutIntervalForRequest = 20
        dataRequest = sessionManager.request(url.relative, method: .put, parameters: parametersTemp, encoding: JSONEncoding.default, headers: header)
        
    }
    
    @discardableResult
    init(deleteRequest url: GGWebKey, parameters: Parameters) {
        super.init()
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        let header = self.getHeader(url)
        GGApiLog.debug("===========Request===========")
        GGApiLog.debug("Url: " + url.relative)
        GGApiLog.debug("Header: " + header.description)
        GGApiLog.debug("Parameter: " + parametersTemp.description)
        GGApiLog.debug("===========Request===========")
        sessionManager.session.configuration.timeoutIntervalForRequest = 20
        dataRequest = sessionManager.request(url.relative, method: .delete, parameters: parametersTemp, encoding: JSONEncoding.default, headers: header)
        
    }
    
    deinit {
        responseHandlerBlock = nil
        dataRequest = nil
    }
    
    @discardableResult
    init(getRequest url: GGWebKey, parameters: Parameters) {
        super.init()
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        let header = self.getHeader(url)

        let urlStr = URL(string: url.relative)
        var urlRequest = URLRequest(url: urlStr!)
        
        urlRequest = try! URLEncoding.queryString.encode(urlRequest, with: parametersTemp)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        for headerValue in header{
            urlRequest.addValue(headerValue.value, forHTTPHeaderField: headerValue.name)
        }
        GGApiLog.debug("===========Request===========")
        GGApiLog.debug("Url: " + url.relative)
        GGApiLog.debug("Header: " + header.description)
        GGApiLog.debug("Parameter: " + parametersTemp.description)
        GGApiLog.debug("===========Request===========")
        sessionManager.session.configuration.timeoutIntervalForRequest = 20
        dataRequest = sessionManager.request(urlRequest)
    }
    
    @discardableResult
    init(uploadRequest url: GGWebKey, parameters: Parameters, method: HTTPMethod) {
        super.init()
        
        var parametersTemp = parameters
        parametersTemp[CWeb.device_id] = UserDetails.shared.device_id
        parametersTemp[CWeb.device_type] = CWeb.device_type_ios
        parametersTemp[CWeb.locale] = UserDetails.shared.langauge
        parametersTemp[CWeb.current_version] = Application.appVersion
        let header = self.getHeader(url)
        
        GGApiLog.debug("===========Request===========")
        GGApiLog.debug("Url: " + url.relative)
        GGApiLog.debug("Method: \(method.rawValue)")
        GGApiLog.debug("Header: " + header.description)
        GGApiLog.debug("Parameter: " + parametersTemp.description)
        GGApiLog.debug("===========Request===========")
        
        
        sessionManager.session.configuration.timeoutIntervalForRequest = 120
        dataRequest = sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.parameter(with: parametersTemp)
        }, to: url.relative, method: method, headers: header)

    }
    
    func cancleApi(){
        dataRequest.cancel()
    }
    
    @discardableResult
    func responseJSON(isShow: Bool = true, responseHandler: @escaping ResponseHandler) -> Self{
        
        self.responseHandlerBlock = responseHandler
        
        if isShow {
            DispatchQueue.main.async {
                GGProgress.shared.showProgress()
            }
        }
        
        if dataRequest == nil {
            return self
        }
        
        dataRequest.responseJSON { response in
            
            debugPrint(response)
            if let r = response.response,  r.statusCode == 401 || r.statusCode == 402{
                debugPrint(response.response)
                if r.statusCode == 402 {
                    UserDetails.isUserLogin = false
                   let login = UIStoryboard.instantiateViewController(withViewClass: SplashScreenController.self)
                   let navi = UINavigationController(rootViewController: login)
                    navi.isNavigationBarHidden = true
                   AppDelegate.shared.window?.rootViewController = navi
                   AppDelegate.shared.window?.makeKeyAndVisible()
                }else{
//                    if r.statusCode == 401 {
//                        UserDetails.isUserLogin = false
//                    }
                    switch response.result{
                    case .success(let resData):
                        let jsonResponse = GGWebError(responseObject: resData as AnyObject)
                        DispatchQueue.main.async {
                            if jsonResponse.errorCode == "1" {
                                self.responseHandlerBlock?(.success(resData as AnyObject, jsonResponse))
                            }
                            else{
                                self.responseHandlerBlock?(.failer(jsonResponse))
                            }
                        }
                        break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.responseHandlerBlock?(.failer(GGWebError(getError: error, data: response.data)))
                        }
                        break
                    }
                }
            }else if let r = response.response, r.statusCode == 410{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                AppDelegate.shared.window?.rootViewController?.present(vc, animated: true)
            }
            else{
                switch response.result{
                case .success(let resData):
                   // GGLog()
                    let jsonResponse = GGWebError(responseObject: resData as AnyObject)
                    
                    DispatchQueue.main.async {
                        if jsonResponse.errorCode == "1" {
                            self.responseHandlerBlock?(.success(resData as AnyObject, jsonResponse))
                        }
                        else{
                            self.responseHandlerBlock?(.failer(jsonResponse))
                        }
                    }
                    break
                    
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        self.responseHandlerBlock?(.failer(GGWebError(getError: error, data: response.data)))
                    }
                    break
                }
            }
            
            DispatchQueue.main.async {
                if isShow {
                    GGProgress.shared.hideProgress()
                }
            }
        }
        
        return self
    }
//
//    fileprivate var uploadEncodingResult: UploadImageHandler {
//        return { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                self.dataRequest = upload
//                guard let block = self.responseHandlerBlock else { break }
//                self.responseJSON(responseHandler: block)
//                break
//
//            case .failure(let error):
//                self.responseHandlerBlock?(.failer(GGWebError(getError: error, data: nil)))
//                GGProgress.shared.hideProgress()
//
//                break
//            }
//        }
//    }
    
    private func getHeader(_ url: GGWebKey) -> HTTPHeaders {
        if UserDetails.isUserLogin{
            let header: HTTPHeaders = [
                "Authorization": "Bearer "+UserDetails.shared.authToken,
                "X-Requested-With":"XMLHttpRequest",
                "Content-Type": "application/json",
                "locale":UserDetails.shared.langauge
            ]
            return header
         }else{
            let header: HTTPHeaders = [
                "X-Requested-With":"XMLHttpRequest",
                "Content-Type": "application/json",
                "locale":UserDetails.shared.langauge
            ]
            return header
        }
    }
}

struct GGImageInfo {
    var fileName: String
    var type: GGContentMIME
    var data: Data
}

enum GGContentMIME: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case mpegAudio = "audio/mpeg"
    case mpeg = "video/mpeg"
    case mpeg4Audio = "audio/mp4"
    case mpeg4 = "video/mp4"
    case none = "*"
}

extension MultipartFormData {
    var timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    func parameter(with parameters: Parameters){
        for param in parameters {
            if let GGImageInfo = param.value as? GGImageInfo {
                append(GGImageInfo.data, withName: param.key, fileName: GGImageInfo.fileName, mimeType: GGImageInfo.type.rawValue)
            }
            else if let GGImageInfo = param.value as? [GGImageInfo] {
                for agImage in GGImageInfo {
                    append(agImage.data, withName: param.key, fileName: agImage.fileName, mimeType: agImage.type.rawValue)
                }
            }
            else if let tempParam = param.value as? [Parameters] {
                debugPrint("Testing=",tempParam)
                for tempP in tempParam {
                    let allKeys = tempP.keys
                    for key in allKeys{
                        if let GGImageInfo = tempP[key] as? GGImageInfo {
                            append(GGImageInfo.data, withName: key, fileName: GGImageInfo.fileName, mimeType: GGImageInfo.type.rawValue)
                        }else if let str = tempP[key] as? String, let convertedValue = str.data(using: String.Encoding.utf8) {
                            append(convertedValue, withName: key)
                        }
                        else if let number = tempP[key] as? NSNumber, let data = "\(number)".data(using: String.Encoding.utf8){
                            append(data, withName: key)
                        }
                        else if let array = tempP[key] as? Array<Any>, let jsonString = array.toJson, let data = jsonString.data(using: String.Encoding.utf8) {
                            append(data, withName: key)
                        }
                        else if let data = (tempP[key] as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                            append(data, withName: key)
                        }
                        else{
                            append("\(tempP[key])".data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                }
            }
            else{
                
                if let str = param.value as? String, let convertedValue = str.data(using: String.Encoding.utf8) {
                    append(convertedValue, withName: param.key)
                }
                else if let number = param.value as? NSNumber, let data = "\(number)".data(using: String.Encoding.utf8){
                    append(data, withName: param.key)
                }
                else if let array = param.value as? Array<Any>, let jsonString = array.toJson, let data = jsonString.data(using: String.Encoding.utf8) {
                    append(data, withName: param.key)
                }
                else if let data = (param.value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    append(data, withName: param.key)
                }
                else{
                    append("\(param.value)".data(using: String.Encoding.utf8)!, withName: param.key)
                }
            }
        }
    }
}

extension UIImage {
    func toData(compration: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: compration)
    }
    
    func resizeImage() -> UIImage {
        
        let image = self
        let size = image.size
        
        var targetSize: CGSize = .zero
        
        if self.size.width > 1024 && self.size.width > self.size.height {
            targetSize.width = 1024
            targetSize.height = (self.size.height * 1024) / self.size.width
        }
        else if self.size.height > 1024 {
            targetSize.height = 1024
            targetSize.width = (self.size.width * 1024) / self.size.height
        }
        else {
            return self
        }
        
        print("Image frame: \(size)")
        print("Image frame: \(targetSize)")
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
