//
//  BaseError.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/6/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit
import SwiftyJSON

public class GGWebError {
    
    var errorCode: String = ""
    var isServerError: Bool = true
    var alertMessage: String = AGString.server_error.local
    
    init() { }
    
    init(getError error: Error, data: Data?) {

        GGApiLog.debug("\n\n===========Error===========")
        GGApiLog.debug("Error Code: \(error._code)")
        GGApiLog.debug("Error Messsage: \(error.localizedDescription)")
        if error._code == 4 {
            if let data = data, let str = String(data: data, encoding: String.Encoding.utf8){
                GGApiLog.debug("Server Error: " + str)
            }
        }
        GGApiLog.debug(error)
        GGApiLog.debug("===========================\n\n")
        
        self.isServerError = false
        self.errorCode = String(error._code)
        
        if error._code != 4 {
            self.alertMessage = error.localizedDescription
        }
    }
    
    init(responseObject: AnyObject){
        
        if let code = responseObject.object(forKey: "success") as? Int {
            errorCode = String(code)
        }
        else if let code = responseObject.object(forKey: "success") as? String {
            errorCode = code
        }
        
        alertMessage = responseObject.object(forKey: "message") as? String ?? ""
        if let error = responseObject.object(forKey: "errors") as? [String:AnyObject]{
            let errorDict =  JSON(responseObject.object(forKey: "errors")!).dictionaryValue
            for (key, value) in errorDict
            {
                print(key, value)
                alertMessage = value[0].stringValue
                errorCode = "0"
                break
            }
        }
        
        if(errorCode == "") {
            errorCode = "1"
        }

        if errorCode != "1" {
            GGApiLog.debug("---------------------");
            GGApiLog.debug("Error Code: %@", errorCode);
            GGApiLog.debug("Alert Message: %@", alertMessage);
            GGApiLog.debug("---------------------");
        }else{
            GGApiLog.debug("---------------------");
            GGApiLog.debug("responseObject : %@", responseObject);
            GGApiLog.debug("---------------------");
        }
    }
}
