//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet var txtOldPassword:GGUnderlineTextField!
    @IBOutlet var txtPassword:GGUnderlineTextField!
    @IBOutlet var txtRepassword:GGUnderlineTextField!
    @IBOutlet var btnSave:AGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setupWhiteTintColor()
        txtOldPassword.placeholder = Language.get("Enter Old Password")
        txtPassword.placeholder = Language.get("Enter Password")
        txtRepassword.placeholder = Language.get("Re-Enter Password")
        self.title = Language.get("Change Password")
        self.btnSave.action = {
            self.BtnSaveAction()
        }
    }
    @objc func BtnSaveAction(){
        if self.txtOldPassword.text! == ""{
            self.displayAlertMsg(string: "Please Enter old password")
        }else if self.txtOldPassword.text!.count < 6{
            self.displayAlertMsg(string: "Please enter valid old password")
        }else if self.txtPassword.text! == ""{
            self.displayAlertMsg(string: "Please Enter password")
        }else if self.txtPassword.text!.count < 6{
            self.displayAlertMsg(string: "Please enter valid password")
        }else  if self.txtRepassword.text! == ""{
            self.displayAlertMsg(string: "Please enter Confirm password")
        }else if self.txtPassword.text! != self.txtRepassword.text!{
            self.displayAlertMsg(string:  "Passwords do not match")
        }else{
            var parameters:GGParameters = [:]
            parameters[CWeb.confirm_password] = self.txtRepassword.text!
            parameters[CWeb.password] = self.txtPassword.text!
            parameters[CWeb.old_password] = self.txtOldPassword.text!
            CommonAPI.shared.changepassword(parameters: parameters) { data in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
