//
//  ProfileVC.swift
//  Logistom3
//
//  Created by HTF India on 9/19/19.
//  Copyright © 2019 TeFe. All rights reserved.
//

import UIKit
var isMyServiceMove = false
var main_category_id = 0
class ProfileViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource  {

    var List:[CategoryModel] = []
    @IBOutlet var table:AGTableView!
    @IBOutlet var lblName:AGLabel!
    @IBOutlet var lblPhone:AGLabel!
    @IBOutlet var lblEmail:AGLabel!

    @IBOutlet var txtNationalityID:GGUnderlineTextField!
    @IBOutlet var txtIDNumber:GGUnderlineTextField!
    @IBOutlet weak var imgIDProff: UIImageView!
    
    @IBOutlet var imgProfile:AGImageView!
    @IBOutlet var imgSignature:AGImageView!
    @IBOutlet var btnEditProfileImg:AGButton!
    @IBOutlet var btnDeleteProfile:AGButton!
    @IBOutlet var btnEditSigneture:AGButton!
    @IBOutlet weak var btnEdit: AGButton!
    
    var path = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = Language.get("Profile")
        if UserDetails.shared.langauge == "ar"{
            self.txtNationalityID.textAlignment = .right
            self.txtIDNumber.textAlignment = .right
        }
        self.btnEditProfileImg.action = {
            AGImagePickerController(with: self, allowsEditing: true, media: .photo, iPadSetup: self.btnEditProfileImg)
        }
        self.btnDeleteProfile.action = {
            var parameters: GGParameters = [:]
            parameters[CWeb.profile_image] = ""
            CommonAPI.shared.updateprofileimage(parameters: parameters, completionHandler: { t in
                self.imgProfile.image = UIImage(named: "user_placeholder")
                UserDetails.shared.convert(dataWith: t)
                UserDetails.shared.profile_image = ""
                UserDetails.shared.saveToUserDefault()
                self.setupLayout()
            })
        }
        self.btnEditSigneture.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: SignatureViewController.self)
            vc.path = self.path
            vc.complitionHander = { (t,p) in
                self.imgSignature.image = t
                self.path = p
                AWSUpload.shared.uploadFile(image: t, path: GGWebKey.image_Upload_signatures_path) { (path,name) in
                    var parameter: GGParameters = [:]
                    parameter[CWeb.signature_file] = name
                    CommonAPI.shared.updatesignature(parameters: parameter, completionHandler: { t in
                        UserDetails.shared.signature_file = name
                        self.setupLayout()
                        UserDetails.shared.saveToUserDefault()
                    })
                }
            }
            vc.modalPresentationStyle = .fullScreen
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.setupBlackTintColor()
            self.present(nav, animated: true) {
                
            }
        }
        btnEdit.action = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLayout()
        CommonAPI.shared.getprofile(parameters: [:]) { data in
            UserDetails.shared.convert(dataWith: data)
            UserDetails.shared.saveToUserDefault()
            self.setupLayout()
            if isMyServiceMove{
                isMyServiceMove = false
                if let indexCatagory = UserDetails.shared.profiles.firstIndex(where: { (model) -> Bool in
                    return model.id == main_category_id
                }){
                    let vc = UIStoryboard.instantiateViewController(withViewClass: ProfileListViewController.self)
                    vc.index = indexCatagory
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    func setupLayout(){
        self.imgProfile.sd_setImage(with: URL(string: UserDetails.shared.profile_image.LoadProvidersImage()), placeholderImage: UIImage(named: "user_placeholder"), options: [], progress: nil, completed: nil)
        self.imgSignature.sd_setImage(with: URL(string: UserDetails.shared.signature_file.LoadSignaturesImage()), placeholderImage: nil, options: [], progress: nil, completed: nil)
        self.imgIDProff.sd_setImage(with: URL(string: UserDetails.shared.id_card_image.LoadIDProffImage()), placeholderImage: UIImage(named: "camera_image"), options: [], progress: nil, completed: nil)
        self.txtIDNumber.text = UserDetails.shared.id_number
        self.txtNationalityID.text = UserDetails.shared.nationality_name
        self.lblName.text = UserDetails.shared.name
        self.lblEmail.text = UserDetails.shared.email
        self.lblPhone.text = "+"+UserDetails.shared.dial_code+" "+UserDetails.shared.mobile
        self.List = []
        for t in UserDetails.shared.profiles {
            self.List.append(t)
        }
        self.table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.List.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.List.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withClassIdentifier: ProfileTableCell.self, for: indexPath)
        cell.setupData(model: self.List[indexPath.row])
        self.table.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.List.count{
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            let vc = UIStoryboard.instantiateViewController(withViewClass: SkillListViewController.self)
            vc.PrevoiusList = self.List
            vc.isFromProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = UIStoryboard.instantiateViewController(withViewClass: ProfileListViewController.self)
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
class ProfileTableCell:UITableViewCell{
    
    @IBOutlet var lblName:AGLabel!
    var object:CategoryModel = CategoryModel()
    @IBOutlet var imgSkill:AGImageView!
    @IBOutlet var imgArroe:AGImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDetails.shared.langauge == "ar"{
            imgArroe.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.lblName.textAlignment = .right
        }
    }
    func setupData(model:CategoryModel){
        self.object = model
        self.lblName.text = self.object.name
        self.imgSkill.setImage(url: self.object.image.LoadCategoriesImage())
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.imgProfile.image = possibleImage
                AWSUpload.shared.uploadFile(image: possibleImage, path: GGWebKey.image_Upload_providers_path) { (path,name) in
                    var parameters: GGParameters = [:]
                    parameters[CWeb.profile_image] = name
                    CommonAPI.shared.updateprofileimage(parameters: parameters, completionHandler: { t in
                        UserDetails.shared.convert(dataWith: t)
                        UserDetails.shared.saveToUserDefault()
                        self.setupLayout()
                    })
                }
                
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }
}

extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return menuBarItem
    }
}
