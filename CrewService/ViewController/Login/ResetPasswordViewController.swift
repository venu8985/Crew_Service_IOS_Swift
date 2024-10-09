//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet var txtPassword:GGUnderlineTextField!
    @IBOutlet var txtRepassword:GGUnderlineTextField!
    @IBOutlet var btnSave:AGButton!
    var isReset = false
    var hash_token: String = ""
    var user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setupWhiteTintColor()
        txtPassword.placeholder = Language.get("Enter Password")
        txtRepassword.placeholder = Language.get("Re-Enter Password")
        self.title = Language.get("Reset Password")
        self.navigationController?.setupBlackTintColor()
        self.btnSave.action = {
            self.BtnSaveAction()
        }
    }
    @objc func BtnSaveAction(){
        if self.txtPassword.text! == ""{
            self.displayAlertMsg(string: "Please Enter password")
        }else if self.txtPassword.text!.count < 6{
            self.displayAlertMsg(string: "Please enter valid password")
        }else  if self.txtRepassword.text! == ""{
            self.displayAlertMsg(string: "Please enter Confirm password")
        }else if self.txtPassword.text! != self.txtRepassword.text!{
            self.displayAlertMsg(string:  "Password and Confirm password not match")
        }else{
            var parameters:GGParameters = [:]
            parameters[CWeb.confirm_password] = self.txtRepassword.text!
            parameters[CWeb.password] = self.txtPassword.text!
            parameters[CWeb.id] = self.user_id
            parameters[CWeb.hash_token] = self.hash_token
            CommonAPI.shared.updatenewpassword(parameters: parameters) { data in
                UserDetails.shared.authToken = data["access_token"] as! String
                CommonAPI.shared.setExpriedTime(values:data["expires_in"] as! Int,type:data["expires_unit"] as! String)
                if let userDic = data["data"] as? [String: AnyObject]{
                    UserDetails.shared.user_id = (userDic["id"] as! NSNumber).description
                    UserDetails.shared.convert(dataWith: userDic)
                    UserDetails.shared.saveToUserDefault()
                }
                UserDetails.isUserLogin = true
                if UserDetails.shared.is_returner == 1{
                     AppDelegate.shared.SetTabBarMainView()
                }else{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: SetupProfileViewController.self)
                    vc.isReset = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
