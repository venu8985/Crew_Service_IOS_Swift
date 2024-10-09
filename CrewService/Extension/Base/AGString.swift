//
//  CString.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit

public enum AGString: String {
    
    case Cancel
    case JustNow = "Just now"
    case ago
    case seconds
    case second
    case minutes
    case minute
    case hours
    case hour
    case days
    case day
    case months
    case month
    case years
    case year
    
    case ChooseOption = "Choose Option"
    case Selectanoptiontopickanimage = "Select an option to pick an image"
    case Camera = "Camera"
    case Photolibrary = "Photo Library"
    case NoMailMessage = "No any mail account found please configure Mail App"
    case ok
    case cancel
    case server_error
    case done = "Done"
    
    var local : String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
class Language: NSObject {

    static var bundle: Bundle? = nil
    
    override init() {
        let defs = UserDefaults.standard
        _ = defs.object(forKey: "AppleLanguages") as? [Any]
        Language.setLanguage("en")
    }

    class func setLanguage(_ l: String?) {
        let path = Bundle.main.path(forResource: l, ofType: "lproj")
        bundle = Bundle(path: path ?? "")
    }
    
    class func get(_ key: String?) -> String {
        let path = Bundle.main.path(forResource: UserDetails.shared.langauge, ofType: "lproj")
        bundle = Bundle(path: path ?? "")
        
        return bundle?.localizedString(forKey: key ?? "", value: key ?? "", table: nil) ?? (key ?? "")
    }
//Language.get("Done", alter: nil) ?? "Done"
}
extension String{
    func Local()->String{
        return Language.get(self)
    }
}
