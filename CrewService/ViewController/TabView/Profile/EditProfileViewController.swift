//
//  EditVC.swift
//  Logistom3
//
//  Created by HTF India on 9/20/19.
//  Copyright © 2019 TeFe. All rights reserved.
//

import UIKit
import CoreLocation
import DropDown


class EditProfileViewController: UIViewController {
    
    @IBOutlet var txtMobilePhone:GGUnderlineTextField!
    @IBOutlet var lblDialCode:UILabel!
    @IBOutlet var btnCountry:AGButton!
    @IBOutlet var viewCountry:UIView!
    @IBOutlet var viewMobile:UIView!
    
    @IBOutlet var txtNationalityID:GGUnderlineTextField!
    @IBOutlet var txtIDNumber:GGUnderlineTextField!
    @IBOutlet var btnNationality:AGButton!
    @IBOutlet weak var imgIDProff: UIImageView!
    @IBOutlet var btnIDProff:AGButton!
    @IBOutlet var txtFullName:GGUnderlineTextField!
    @IBOutlet var txtEmail:GGUnderlineTextField!
    @IBOutlet weak var btnSave: AGButton!
    var id_card_image = ""
    var nationality_id = 0
    var nationalitys:[NationalityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Edit Profile")
        self.txtMobilePhone.isMobileCalled = true
        self.txtMobilePhone.changeSementics()
      
        self.txtFullName.text = UserDetails.shared.name
        self.txtEmail.text = UserDetails.shared.email
        self.txtMobilePhone.text = UserDetails.shared.mobile
        self.txtIDNumber.text = UserDetails.shared.id_number
        self.txtNationalityID.text = UserDetails.shared.nationality_name
        self.imgIDProff.sd_setImage(with: URL(string: UserDetails.shared.id_card_image.LoadIDProffImage()), placeholderImage: UIImage(named: "camera_image"), options: [], progress: nil, completed: nil)
        self.nationality_id = UserDetails.shared.nationality_id
        self.lblDialCode.text = "+" + UserDetails.shared.dial_code.description
        btnCountry.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: CountryListViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.completetion = { t in
                self.lblDialCode.text = "+" + UserDetails.shared.selectedCountry.dial_code.description
            }
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }
        if UserDetails.shared.langauge == "ar"{
            self.txtFullName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtMobilePhone.textAlignment = .right
            self.txtNationalityID.textAlignment = .right
            self.txtIDNumber.textAlignment = .right
            viewMobile.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblDialCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            txtMobilePhone.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        btnIDProff.action = {
            AGImagePickerController(with: self, allowsEditing: true, media: .photo, iPadSetup: self.btnIDProff)
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
        btnSave.action = {
            
            if self.txtFullName.text == ""{
                self.view.makeToast("Please enter Name")
            }else if self.txtEmail.text == ""{
                self.view.makeToast("Please enter valid email address")
            }else if self.txtMobilePhone.text == ""{
                self.view.makeToast("Please enter valid mobile number")
            }else if self.nationality_id == 0{
                self.view.makeToast("Please selete Nationality")
            }else if self.txtNationalityID.text == ""{
                self.view.makeToast("Please enter valid ID number")
            }else if self.id_card_image == ""{
                self.displayAlertMsg(string: "Please upload ID Photo")
            }else{
                var parameters:GGParameters = [:]
                parameters[CWeb.dial_code] = UserDetails.shared.selectedCountry.dial_code
                parameters[CWeb.name] = self.txtFullName.text!
                parameters[CWeb.mobile] = self.txtMobilePhone.text!
                parameters[CWeb.email] = self.txtEmail.text!
                parameters[CWeb.id_number] = self.txtIDNumber.text!
                parameters[CWeb.id_card_image] = self.id_card_image
                parameters[CWeb.nationality_id] = self.nationality_id
                CommonAPI.shared.updateprofile(parameters: parameters) { t in
                    UserDetails.shared.name = self.txtFullName.text!
                    UserDetails.shared.email = self.txtEmail.text!
                    UserDetails.shared.mobile = self.txtMobilePhone.text!
                    UserDetails.shared.id_card_image = self.id_card_image
                    UserDetails.shared.id_number = self.txtIDNumber.text!
                    UserDetails.shared.nationality_id = self.nationality_id
                    UserDetails.shared.nationality_name = self.txtNationalityID.text!
                    UserDetails.shared.saveToUserDefault()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                AWSUpload.shared.uploadFile(image: possibleImage, path: GGWebKey.image_Upload_id_cards_path) { (path,name) in
                    DispatchQueue.main.async(execute: {
                        self.imgIDProff.image = possibleImage
                    })
                    self.id_card_image = name
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }

}
