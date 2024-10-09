//
//  ProfileListViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 10/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class ProfileListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {

    var object:CategoryModel = CategoryModel()
    @IBOutlet var table:UITableView!
    var index:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDetails.shared.profiles.count > index{
            self.object = UserDetails.shared.profiles[index]
        }
        self.table.reloadData()
        self.title = self.object.name
        self.table.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDetails.shared.profiles.count > index{
            self.object = UserDetails.shared.profiles[index]
        }
        self.table.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.profiles.count < self.object.max_selection_allowed {
            return self.object.profiles.count+1
        }else{
            return self.object.profiles.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.object.profiles.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withClassIdentifier: ProfileListTableViewCell.self, for: indexPath)
        cell.setupData(model: self.object.profiles[indexPath.row])
        cell.completionDelete = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            var parameters: GGParameters = [:]
            parameters[CWeb.provider_profile_id] = self.object.profiles[indexPath.row].id
            CommonAPI.shared.deleteprofile(parameters: parameters, completionHandler: { t in
                UserDetails.shared.profiles[self.index].profiles.remove(at: indexPath.row)
                self.table.reloadData()
            })
        }
        cell.completionEdit = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            let vc = UIStoryboard.instantiateViewController(withViewClass: AddProfileViewController.self)
            vc.isEdit = true
            vc.object = self.object
            vc.List = [self.object.profiles[indexPath.row]]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.table.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDetails.shared.profile_status != "Verified"{
            self.OpenReviewPopupScreen()
            return
        }
        if indexPath.row == self.object.profiles.count{
            CommonAPI.shared.category(parameters: [CWeb.category_id:self.object.id]) { data in
                self.object.children <= data
                let vc = UIStoryboard.instantiateViewController(withViewClass: TelentListViewController.self)
                vc.object = self.object
                vc.isFromProfile = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = UIStoryboard.instantiateViewController(withViewClass: AddProfileViewController.self)
            vc.isDisplay = true
            vc.object = self.object
            vc.List = [self.object.profiles[indexPath.row]]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
class ProfileListTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName:AGLabel!
    @IBOutlet var lblPrice:AGLabel!
    @IBOutlet var lblAddress:AGLabel!
    @IBOutlet var imgUser:AGImageView!
    
    @IBOutlet var btnEdit:AGButton!
    @IBOutlet var btnDelete:AGButton!
    
    var object:ProviderModel = ProviderModel()
    var completionEdit:(()->Void)?
    var completionDelete:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnEdit.action = {
            self.completionEdit?()
        }
        self.btnDelete.action = {
            self.completionDelete?()
        }
        if UserDetails.shared.langauge == "ar"{
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right
            self.lblAddress.textAlignment = .right
        }
    }
    func setupData(model:ProviderModel){
        self.object = model
        self.lblName.text = self.object.category_name
        self.lblPrice.text = self.object.charges.PriceString()+"/"+self.object.charges_unit.loadUnit()
        self.lblAddress.text = self.object.descriptions
//        self.imgUser.setImage(url: self.object.image.LoadUserImage(), placeholderImage: UIImage(named: "placeholder")!)
    }
}
