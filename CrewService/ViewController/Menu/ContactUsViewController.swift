//
//  ContactUsViewController.swift
//  HTF
//
//  Created by Gaurav Gudaliya R on 29/04/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet var txtFullName:GGUnderlineTextField!
    @IBOutlet var txtEmail:GGUnderlineTextField!
    @IBOutlet var txtMobilePhone:GGUnderlineTextField!
    @IBOutlet var txtMessage:AGTextView!
    @IBOutlet var btnSubmite:AGButton!
    @IBOutlet var lblDialCode:UILabel!
    @IBOutlet var btnCountry:AGButton!
    @IBOutlet var viewLogin:UIView!
    var selectedCountry:CountryModel = CountryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Contact Us")
        self.txtMessage.placeholder = Language.get("Enter Feedback")
        self.navigationController?.setupWhiteTintColor()
        self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
        if UserDetails.shared.langauge != "en"{
            self.txtMobilePhone.isMobileCalled = true
            viewLogin.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblDialCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            txtMobilePhone.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        if UserDetails.isUserLogin{
            self.selectedCountry = CommonAPI.shared.arrCountryList.first(where: { (model) -> Bool in
            return model.dial_code == UserDetails.shared.dial_code }) ?? CommonAPI.shared.arrCountryList[0]
            
            self.txtFullName.text = UserDetails.shared.name
            self.txtEmail.text = UserDetails.shared.email
            self.txtMobilePhone.text = UserDetails.shared.mobile
            self.lblDialCode.text = "+" + self.selectedCountry.dial_code.description
        }
        btnCountry.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: CountryListViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.completetion = { t in
                self.selectedCountry = t
                self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
            }
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }
        btnSubmite.action = {
            
            if self.txtFullName.text! == "" {
                self.view.makeToast("Please enter Name")
            }else if self.txtEmail.text == ""{
                self.view.makeToast("Please enter valid email address")
            }else if self.txtMobilePhone.text == ""{
                self.view.makeToast("Please enter valid mobile number")
            }else if self.txtMessage.text == ""{
                self.view.makeToast("Message field is required")
            }
            else{
                var parameters:GGParameters = [:]
                parameters[CWeb.name] = self.txtFullName.text!
                parameters[CWeb.dial_code] = self.selectedCountry.dial_code
                parameters[CWeb.mobile] = self.txtMobilePhone.text!
                parameters[CWeb.email] = self.txtEmail.text!
                parameters[CWeb.message] = self.txtMessage.text!
                CommonAPI.shared.submitfeedback(parameters: parameters) { data in
                    let vc = UIStoryboard.instantiateViewController(withViewClass: AfterAddCommnetViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
