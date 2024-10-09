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
import Firebase
import FirebaseAnalytics

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtMobilePhone:GGUnderlineTextField!
    @IBOutlet var lblDialCode:UILabel!
    @IBOutlet var btnCountry:AGButton!
    @IBOutlet var viewCountry:UIView!
    @IBOutlet var viewMobile:UIView!
    
    @IBOutlet var txtPassword:GGUnderlineTextField!
    @IBOutlet var btnSignWithSMS:AGButton!
    @IBOutlet var btnSignWithPassword:AGButton!
    
    @IBOutlet var btnSignIn1:AGButton!
    @IBOutlet var btnSignIn2:AGButton!
    
    @IBOutlet var btnForgetPassword:AGButton!
    @IBOutlet var viewSMS:UIStackView!
    @IBOutlet var viewPassword:UIStackView!
  
    @IBOutlet var btnTC:AGButton!
    @IBOutlet var btnPP:AGButton!
    @IBOutlet var btnTCCheck:AGButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UserDetails.shared.selectedCountry.dial_code = "966"
        CommonAPI.shared.country(parameters: [:]) { data in
            if let _ = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                UserDetails.shared.selectedCountry = CommonAPI.shared.arrCountryList.first(where: { (model) -> Bool in
                    return model.dial_code == "966" }) ?? CommonAPI.shared.arrCountryList[0]
            }
            self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
        }
        
        CommonAPI.shared.appsettings(parameters: [:], completionHandler: { data in
            if let tt =  data["version"] as? String,(Float(Application.appVersion) ?? 0.0) < (Float(tt) ?? 0.0){
                let vc = UIStoryboard.instantiateViewController(withViewClass: UpdateVersionViewController.self)
                vc.version = tt
                vc.comment =  data["update_description"] as? String ?? ""
                vc.modalPresentationStyle = .fullScreen
                AppDelegate.shared.present(VC: vc, animated: true)
                
            }else{
                if let tt = data["version"] as? String,(Float(Application.appVersion) ?? 0.0) > (Float(tt) ?? 0.0){
                    CheckAppUpdateModel.shared.checkAppUpdate { (model) in
                        if model.updateType != .unknown{
                            let vc = UIStoryboard.instantiateViewController(withViewClass: UpdateVersionViewController.self)
                            vc.version = tt
                            vc.comment =  data["update_description"] as? String ?? ""
                            vc.modelVersion = model
                            vc.modalPresentationStyle = .fullScreen
                            AppDelegate.shared.present(VC: vc, animated: true)
                        }
                    } completetionErrorHandler: { (error) in
                        debugPrint(error)
                    }
                }
            }
         })
        
        btnTCCheck.action = {
            self.btnTCCheck.isSelected = !self.btnTCCheck.isSelected
        }
        self.btnPP.action = {
            let VC = UIStoryboard.instantiateViewController(withViewClass: WebViewController.self)
            VC.type = .pp
            AppDelegate.shared.pushViewController(VC: VC, animated: false)
        }
        self.btnForgetPassword.action = {
            let VC = UIStoryboard.instantiateViewController(withViewClass: ForgetViewController.self)
            AppDelegate.shared.pushViewController(VC: VC, animated: true)
        }
        self.btnTC.action = {
            let VC = UIStoryboard.instantiateViewController(withViewClass: WebViewController.self)
            VC.type = .tc
            AppDelegate.shared.pushViewController(VC: VC, animated: false)
        }
        self.navigationController?.setupBlackTintColor()
        if UserDetails.shared.langauge != "en"{
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
        //addSkipButton()
        addLangagueButton()
        
        self.txtMobilePhone.delegate = self
        self.viewCountry.isHidden = false
        
        self.viewSMS.isHidden = false
        self.viewPassword.isHidden = true
        
        btnSignWithSMS.action = {
            self.viewSMS.isHidden = false
            self.viewPassword.isHidden = true
        }
        btnSignWithPassword.action = {
            self.viewSMS.isHidden = true
            self.viewPassword.isHidden = false
        }
        btnSignIn1.action = {
            if self.txtMobilePhone.text!.isNull{
                self.displayAlertMsg(string: "Please enter valid mobile number")
            }else if !self.btnTCCheck.isSelected{
                self.displayAlertMsg(string: "Please accept Term Condition")
            }else{
                var parameters:GGParameters = [:]
                parameters[CWeb.dial_code] = UserDetails.shared.selectedCountry.dial_code
                parameters[CWeb.mobile] = self.txtMobilePhone.text!
                parameters[CWeb.password] = ""
                parameters[CWeb.fcm_id] = UserDetails.shared.fcm_id
                parameters[CWeb.device_id] = UserDetails.shared.device_id
                parameters[CWeb.login_mode] = "OTP"
                CommonAPI.shared.login(parameters: parameters, completionHandler: { data in
                    let vc = UIStoryboard.instantiateViewController(withViewClass: SecurityCodeViewController.self)
                    vc.user_id = data["id"] as? String ?? (data["id"] as! Int).description
                    vc.hash_token = (data["token"] as! String)
                    vc.mobileNo = self.lblDialCode.text!+"-"+self.txtMobilePhone.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                }) { error in
                    
                }
            }
        }
        btnSignIn2.action = {
            if self.txtMobilePhone.text!.isNull{
                self.displayAlertMsg(string: "Please enter valid mobile")
            }else if self.txtPassword.text!.isNull{
                self.displayAlertMsg(string: "Please enter valid Password")
            }else if self.txtPassword.text!.count < 6{
                self.displayAlertMsg(string: "Password must be grater then 6 digits")
            }else{
                var parameters:GGParameters = [:]
                parameters[CWeb.dial_code] = UserDetails.shared.selectedCountry.dial_code
                parameters[CWeb.password] = self.txtPassword.text!
                parameters[CWeb.mobile] = self.txtMobilePhone.text!
                parameters[CWeb.fcm_id] = UserDetails.shared.fcm_id
                parameters[CWeb.device_id] = UserDetails.shared.device_id
                parameters[CWeb.login_mode] = "Password"
                CommonAPI.shared.login(parameters: parameters, completionHandler: { data in
                    UserDetails.shared.authToken = data["access_token"] as! String
                    CommonAPI.shared.setExpriedTime(values:data["expires_in"] as! Int,type:data["expires_unit"] as! String)
                    if let userDic = data["data"] as? [String: AnyObject]{
                        UserDetails.shared.user_id = (userDic["id"] as! NSNumber).description
                        UserDetails.shared.convert(dataWith: userDic)
                        UserDetails.shared.saveToUserDefault()
                    }
                    UserDetails.isUserLogin = true
                    AppDelegate.shared.SetTabBarMainView()
                }) { error in
                    
                }
            }
        }
        self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
        self.txtMobilePhone.isMobileCalled = true
        self.txtMobilePhone.changeSementics()
        if UserDetails.shared.langauge != "en"{
            viewMobile.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblDialCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            txtMobilePhone.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
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
    func addLangagueButton(){
        let customButton = AGButton(type: UIButton.ButtonType.custom)
        //customButton.frame = CGRect(x: 0, y: 0, width: 90.0, height: 30.0)
        if UserDetails.shared.langauge == "en"{
            customButton.setTitle(Language.get("ARABIC"), for: .normal)
        }else{
            customButton.setTitle(Language.get("ENGLISH"), for: .normal)
        }
        customButton.setImage(UIImage(named: "language"), for: .normal)
        customButton.titleLabel?.font = UIFont.init(name: "AvenirLTStd-Black", size: 12.0) ?? UIFont.boldSystemFont(ofSize: 12)
        customButton.setTitleColor(.black, for: .normal)
        customButton.backgroundColor = UIColor(hex: 0xEEEEEE)
        customButton.addTarget(self, action: #selector(self.changeLangague), for: .touchUpInside)
        
        customButton.cornerRadius = 5
        customButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: customButton), animated: true)
    }
    @objc func changeLangague(){
        if UserDetails.shared.langauge != "en"{
            UserDetails.shared.langauge = "en"
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else{
            UserDetails.shared.langauge = "ar"
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = AGString.cancel.local
        let VC = UIStoryboard.instantiateViewController(withViewClass: LoginViewController.self)
        AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: VC)
        //self.replaceViewController(controller: VC)
    }
}
