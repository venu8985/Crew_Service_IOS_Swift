//
//  CallMeViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 06/04/19.
//  Copyright © 2019 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
class SplashScreenController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonAPI.shared.country(parameters: [:]) { data in
            if let _ = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                UserDetails.shared.selectedCountry = CommonAPI.shared.arrCountryList.first(where: { (model) -> Bool in
                    return model.dial_code == "966" }) ?? CommonAPI.shared.arrCountryList[0]
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDetails.isUserLogin{
            AppDelegate.shared.SetTabBarMainView()
        }else{
            let vc = UIStoryboard.instantiateViewController(withViewClass: LoginViewController.self)
            AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
}
