//
//  LoginViewController.swift
//  HTF
//
//  Created by Gaurav Gudaliya R on 27/04/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SafariServices

class ForgetViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtMobilePhone:GGUnderlineTextField!
    @IBOutlet var lblDialCode:UILabel!
    @IBOutlet var btnCountry:AGButton!
    @IBOutlet var viewCountry:UIView!
    @IBOutlet var viewMobile:UIView!

    @IBOutlet var btnSignIn1:AGButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Language.get("Forgot Password")
        self.txtMobilePhone.placeholder = Language.get("Mobile Number")

        self.navigationController?.setupBlackTintColor()
        if UserDetails.shared.langauge != "en"{
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
      
        self.txtMobilePhone.delegate = self
        
        btnSignIn1.action = {
            if self.txtMobilePhone.text!.isNull{
                self.displayAlertMsg(string: "Please enter valid email/mobile")
            }else{
                var parameters:GGParameters = [:]
                parameters[CWeb.dial_code] = UserDetails.shared.selectedCountry.dial_code
                parameters[CWeb.mobile] = self.txtMobilePhone.text!
                CommonAPI.shared.forgotpassword(parameters: parameters, completionHandler: { data in
                    UserDetails.shared.user_id = (data["id"] as! Int).description
                    let vc = UIStoryboard.instantiateViewController(withViewClass: SecurityCodeViewController.self)
                    vc.isForgetPassword = true
                    vc.user_id = data["id"] as? String ?? (data["id"] as! Int).description
                    vc.hash_token = (data["token"] as! String)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
        self.update()
        self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
        btnCountry.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: CountryListViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.completetion = { t in
                self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
            }
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }
    }

    func update(){
        self.txtMobilePhone.isMobileCalled = true
        self.txtMobilePhone.changeSementics()
        if UserDetails.shared.langauge != "en"{
            viewMobile.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblDialCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            txtMobilePhone.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}
