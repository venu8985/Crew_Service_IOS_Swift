//
//  UserDetails.swift
//  Alfayda
//
//  Created by Wholly-iOS on 25/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit
import CoreLocation

class UserDetails: AGObject {
    
    static var shared = UserDetails()
    static var appVersionAndBulid: String {
        return UserDefaults.standard.string(forKey: "appVersion") ?? ""
    }
    
    var user_id: String {
        get { return UserDefaults.standard.string(forKey: "user_id") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "user_id") }
    }
    
    var langauge: String {
        get { return UserDefaults.standard.string(forKey: "langauge") ?? "en" }
        set {
            if newValue == "en"{
                Bundle.setLanguage("en")
            }else{
                Bundle.setLanguage("ar")
            }
            UserDefaults.standard.set(newValue, forKey: "langauge")
        }
    }
    
    static var isUserLogin: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isUserLogin")
        }
        
        set{
            if newValue {
                UserDefaults.standard.set(Application.appVersion + Application.appBuild, forKey: "appVersion")
            }
            UserDefaults.standard.set(newValue, forKey: "isUserLogin")
        }
    }
    var device_id:String{
        get{
            return UniquiUdid.App.UDID
        }
        set{
            
        }
    }
    var fcm_id: String {
        get { return UserDefaults.standard.string(forKey: "fcm_id") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "fcm_id") }
    }

    var selectedCountry:CountryModel = CountryModel()
    var profiles: [CategoryModel] = []
    override init() {
        super.init()
        if authToken.isNull {
            self.getDataFromUserDefault()
        }
    }
    var arrCountry: [CountryModel] = []{
        didSet{
            var t:[String:Any] = [:]
            t["arrCountry"] = arrCountry.toDict
            UserDefaults.standard.set(t, forKey: "arrCountry")
        }
    }
    func clear() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            
            print("Clear ValuesCount :- \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
            self.name = ""
            self.profile_image = ""
            self.dial_code = ""
            self.mobile = ""
            self.email = ""
            self.is_returner = 0
            self.job_accepted = 0
            self.job_cancelled = 0
            self.job_completed = 0
            self.job_received = 0
            self.totalProfiles = 0
            self.total_rated = 0
            self.total_rating = 0
            self.total_reviews = 0
            self.wallet_amount = 0.0
            self.rating = 0.0
            self.last_profile_description = ""
            self.signature_file = ""
            self.profiles = []
        }
    }
    var authToken: String = ""
    var id = 0
    var name = ""
    var profile_image = ""
    var profile_status = ""
    var dial_code = ""
    var mobile = ""
    var email = ""
    var activate_trial = 0
    var expired_at = ""
    var payment_status = ""
    var registration_fees = ""
    var renewal_remind_at = ""
    var locale = ""
    var is_returner = 0
    var job_accepted = 0
    var job_cancelled = 0
    var job_completed = 0
    var job_received = 0
    var totalProfiles = 0
    var total_rated = 0
    var total_rating = 0
    var total_reviews = 0
    var wallet_amount = 0.0
    var rating = 0.0
    var last_profile_description = ""
    var signature_file = ""
    var nationality_id = 0
    var id_card_image = ""
    var id_number = ""
    var nationality_name = ""
    
    func showGoogleDirection(latitude: CLLocationDegrees, longitude: CLLocationDegrees,address:String?) {
        if latitude != 0.0,longitude != 0.0{
            AGLocationManager.oneTime.updateLocation(complitionHandler: { (result) in
                switch result{
                case .success(let t):
                    if let aString = URL(string: "comgooglemaps://") {
                        if UIApplication.shared.canOpenURL(aString) {
                            let strG = "com.google.maps://?saddr=\(t.coordinate.latitude),\(t.coordinate.longitude)&daddr=\(latitude),\(longitude)&directionsmode=driving"
                            if let aG = URL(string: strG) {
                                UIApplication.shared.open(aG, options: [:], completionHandler: nil)
                            }
                        }
                    }else{
                        let strG = "https://maps.google.com://?saddr=\(t.coordinate.latitude),\(t.coordinate.longitude)&daddr=\(latitude),\(longitude)&directionsmode=driving"
                        if let aG = URL(string: strG) {
                            UIApplication.shared.open(aG, options: [:], completionHandler: nil)
                        }
                    }
                case .failer( _ ):
                    break
                }
            })
        }
    }
}

class Application: NSObject {
    
    /// EZSE: Returns app's version number
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// EZSE: Return app's build number
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }
}
