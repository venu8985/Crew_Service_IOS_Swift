//
//  SetupProfileViewController.swift
//  HTF
//
//  Created by Gaurav Gudaliya R on 27/04/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import DropDown

class SetupProfileViewController: UIViewController {

    @IBOutlet var txtFullName:GGUnderlineTextField!
    @IBOutlet var txtEmail:GGUnderlineTextField!
    @IBOutlet var txtMobilePhone:GGUnderlineTextField!
    @IBOutlet var txtPassword:GGUnderlineTextField!
    @IBOutlet var txtNationalityID:GGUnderlineTextField!
    @IBOutlet var txtIDNumber:GGUnderlineTextField!
    @IBOutlet var btnNationality:AGButton!
    @IBOutlet weak var imgIDProff: UIImageView!
    @IBOutlet var btnIDProff:AGButton!
    @IBOutlet var btnSaveProfile:AGButton!
    @IBOutlet var lblSigneture:AGLabel!
    @IBOutlet var viewLogin:UIView!
    @IBOutlet var imgProfile:AGImageView!
    @IBOutlet weak var imgSignature: UIImageView!
    @IBOutlet var btnClearPad:AGButton!
    @IBOutlet var btnEditProfileImg:AGButton!
    @IBOutlet var viewPassword:AGView!
    var profile_image = ""
    var strSignature = ""
    var id_card_image = ""
    var selectedCountry:CountryModel = CountryModel()
    var isResubmit = false
    var isProfile = true
    var path = UIBezierPath()
    var isReset = false
    var nationality_id = 0
    var nationalitys:[NationalityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setupBlackTintColor()
        self.title = Language.get("Setup Your Profile")
        self.imgProfile.image = UIImage(named: "add_profile")
        self.txtMobilePhone.isUserInteractionEnabled = false
        if self.isResubmit{
            self.navigationController?.setupWhiteTintColor()
            self.imgProfile.sd_setImage(with: URL(string: UserDetails.shared.profile_image.LoadUserImage()), placeholderImage: UIImage(named: "user-1"), options: [], progress: nil, completed: nil)
            self.txtFullName.text = UserDetails.shared.name
            self.txtEmail.text = UserDetails.shared.email
            self.txtMobilePhone.text =  UserDetails.shared.dial_code+" "+UserDetails.shared.mobile
        }else{
            self.navigationController?.navigationItem.hidesBackButton = true
            self.navigationItem.hidesBackButton = true
            self.navigationItem.setHidesBackButton(true, animated: true);
        }
        CommonAPI.shared.country(parameters: [:]) { data in
            self.selectedCountry = CommonAPI.shared.arrCountryList.first(where: { (model) -> Bool in
                return model.dial_code == UserDetails.shared.dial_code }) ?? CommonAPI.shared.arrCountryList[0]
        }
        
        self.txtMobilePhone.text = UserDetails.shared.mobile
        self.txtEmail.text = UserDetails.shared.email
        self.viewPassword.isHidden = isReset
        if UserDetails.shared.mobile != ""{
             self.txtMobilePhone.isUserInteractionEnabled = false
        }
        if UserDetails.shared.langauge != "en"{
            self.txtFullName.textAlignment = .right
            self.txtEmail.textAlignment = .right
             self.txtPassword.textAlignment = .right
            self.txtNationalityID.textAlignment = .right
            self.txtIDNumber.textAlignment = .right
            self.txtMobilePhone.textAlignment = .right
            
            viewLogin.transform = CGAffineTransform(scaleX: -1, y: 1)
            txtMobilePhone.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
       
        btnEditProfileImg.action = {
            self.isProfile = true
            AGImagePickerController(with: self, allowsEditing: true, media: .photo, iPadSetup: self.btnEditProfileImg)
        }
        btnIDProff.action = {
            self.isProfile = false
            AGImagePickerController(with: self, allowsEditing: true, media: .photo, iPadSetup: self.btnIDProff)
        }
        btnClearPad.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: SignatureViewController.self)
            vc.path = self.path
            vc.complitionHander = { (t,p) in
                self.imgSignature.image = t
                self.lblSigneture.isHidden = true
                self.path = p

                AWSUpload.shared.uploadFile(image: t, path: GGWebKey.image_Upload_signatures_path) { (path,name) in
                    self.strSignature = name
                }
            }
            vc.modalPresentationStyle = .fullScreen
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.setupBlackTintColor()
            self.present(nav, animated: true) {
                
            }
        }
        self.btnNationality.action = {
            func open(){
                let dropDown = DropDown()
                dropDown.topOffset = CGPoint(x: 0, y: 50)
                dropDown.anchorView = self.btnNationality
                dropDown.direction = .bottom
                dropDown.backgroundColor = .white
                dropDown.textColor = .black
                dropDown.textFont = UIFont(name: "AvenirLTStd-Black", size: 12) ?? UIFont.systemFont(ofSize: 12)
                dropDown.dataSource = self.nationalitys.map{$0.nationality_name}
                dropDown.show()
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    dropDown.hide()
                    self.nationality_id = self.nationalitys[index].id
                    self.txtNationalityID.text = item
                }
            }
            if self.nationalitys.count == 0{
                CommonAPI.shared.nationality(parameters: [:]) { data in
                    self.nationalitys <= data
                    open()
                }
            }else{
                open()
            }
        }
        btnSaveProfile.action = {
            if self.txtFullName.text == ""{
                self.view.makeToast("Please enter Name")
            }else if self.txtEmail.text == ""{
                self.view.makeToast("Please enter valid email address")
            }else if self.txtMobilePhone.text == ""{
                self.view.makeToast("Please enter valid mobile number")
            }else if self.txtPassword.text! == "" && !self.isReset{
                self.displayAlertMsg(string: "Enter Password")
            }else if self.txtPassword.text!.count < 6 && !self.isReset{
                self.displayAlertMsg(string: "Please enter valid password")
            }else if self.strSignature == ""{
                self.displayAlertMsg(string: "Signature can not be empty")
            }else if self.nationality_id == 0{
                self.view.makeToast("Please selete Nationality")
            }
            else{
                if self.isReset{
                    var parameters:GGParameters = [:]
                   parameters[CWeb.dial_code] = self.selectedCountry.dial_code
                   parameters[CWeb.name] = self.txtFullName.text!
                   parameters[CWeb.mobile] = self.txtMobilePhone.text!
                   parameters[CWeb.email] = self.txtEmail.text!
                   parameters[CWeb.signature_file] = self.strSignature
                   parameters[CWeb.profile_image] = self.profile_image
                    parameters[CWeb.id_number] = self.txtNationalityID.text!
                    if self.id_card_image != ""{
                        parameters[CWeb.id_card_image] = self.id_card_image
                    }
                    parameters[CWeb.nationality_id] = self.nationality_id
                   CommonAPI.shared.completeprofilewithoutpassword(parameters: parameters) { t in
                       UserDetails.shared.user_id = (t["id"] as! NSNumber).description
                       UserDetails.shared.convert(dataWith: t)
                       UserDetails.shared.is_returner = 1
                       UserDetails.shared.saveToUserDefault()
                       if self.isResubmit{
                           self.navigationController?.popViewController(animated: false)
                       }else{
                            AppDelegate.shared.SetTabBarMainView()
                       }
                   }
                }else{
                    var parameters:GGParameters = [:]
                   parameters[CWeb.dial_code] = self.selectedCountry.dial_code
                   parameters[CWeb.name] = self.txtFullName.text!
                   parameters[CWeb.mobile] = self.txtMobilePhone.text!
                   parameters[CWeb.email] = self.txtEmail.text!
                   parameters[CWeb.password] = self.txtPassword.text!
                   parameters[CWeb.confirm_password] = self.txtPassword.text!
                   parameters[CWeb.signature_file] = self.strSignature
                   parameters[CWeb.profile_image] = self.profile_image
                    parameters[CWeb.id_number] = self.txtNationalityID.text!
                    if self.id_card_image != ""{
                        parameters[CWeb.id_card_image] = self.id_card_image
                    }
                    parameters[CWeb.nationality_id] = self.nationality_id
                   CommonAPI.shared.completeprofile(parameters: parameters) { t in
                       UserDetails.shared.user_id = (t["id"] as! NSNumber).description
                       UserDetails.shared.convert(dataWith: t)
                       UserDetails.shared.is_returner = 1
                       UserDetails.shared.saveToUserDefault()
                       if self.isResubmit{
                           self.navigationController?.popViewController(animated: false)
                       }else{
                            AppDelegate.shared.SetTabBarMainView()
                       }
                   }
                }
                
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                if self.isProfile{
                    AWSUpload.shared.uploadFile(image: possibleImage, path: GGWebKey.image_Upload_providers_path) { (path,name) in
                        DispatchQueue.main.async(execute: {
                            self.imgProfile.image = possibleImage
                        })
                        self.profile_image = name
                    }
                }else{
                    AWSUpload.shared.uploadFile(image: possibleImage, path: GGWebKey.image_Upload_id_cards_path) { (path,name) in
                        DispatchQueue.main.async(execute: {
                            self.imgIDProff.image = possibleImage
                        })
                        self.id_card_image = name
                    }
                }
               // self.updateprofilePic()
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }

}
