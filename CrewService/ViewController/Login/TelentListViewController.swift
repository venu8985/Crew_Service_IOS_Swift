//
//  TelentListViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/05/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class TelentListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {
    
    @IBOutlet var table:UITableView!
    @IBOutlet var selectedTable:AGTableView!
    @IBOutlet var selectedListView:UIView!
    @IBOutlet var txtSearch:UITextField!
    @IBOutlet var lblMaxCount:AGLabel!
    var object:CategoryModel = CategoryModel()
    var selectedSubCategory:[SubCategoryModel] = []
    var previousSubCategory:[SubCategoryModel] = []
    var listCatagory:[SubCategoryModel] = []
    @IBOutlet var btnNext:AGButton!
    var isFromProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.object.name
        if UserDetails.shared.langauge == "ar"{
            self.txtSearch.textAlignment = .right
        }
        self.txtSearch.placeholder = Language.get("Search your talent")
        self.lblMaxCount.text = String(format: Language.get("You can add maximum %d skills"), self.object.max_selection_allowed)
        if isFromProfile{
            self.lblMaxCount.isHidden = false
        }else{
            self.lblMaxCount.isHidden = true
        }
        self.selectedListView.isHidden = true
        self.btnNext.setTitleColor(.appOffGray, for: .normal)
        self.btnNext.backgroundColor = .appOffWhite
        
        if self.isFromProfile{
            let indexMap = self.object.profiles.map({$0.child_category_id})
            var children: [SubCategoryModel] = []
            for t in self.object.children{
                if indexMap.contains(t.id){
                    self.previousSubCategory.append(t)
                }else{
                    children.append(t)
                }
            }
            self.listCatagory = children
            if self.previousSubCategory.count > 0{
                self.selectedListView.isHidden = false
            }
        }else{
            self.listCatagory = self.object.children
        }
        self.btnNext.action = {
            if self.selectedSubCategory.count == 0{return}
            let vc = UIStoryboard.instantiateViewController(withViewClass: AddProfileViewController.self)
            vc.isFromProfile = self.isFromProfile
            vc.object = self.object
            vc.subCatagory = self.selectedSubCategory
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
        self.table.tableFooterView = UIView()
        self.table.reloadData()
        
        self.selectedTable.tableFooterView = UIView()
        self.selectedTable.reloadData()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.table{
            return self.listCatagory.count
        }else{
            return self.previousSubCategory.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.table{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TelentTableCell", for: indexPath) as! TelentTableCell
            cell.setupData(model: self.listCatagory[indexPath.row])
            cell.viewBG.backgroundColor = .white
            if self.selectedSubCategory.contains(self.listCatagory[indexPath.row]){
                cell.btnSelect.isSelected = true
            }else{
                cell.btnSelect.isSelected = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TelentTableCell", for: indexPath) as! TelentTableCell
            cell.setupData(model: self.previousSubCategory[indexPath.row])
            cell.btnSelect.isSelected = true
            cell.viewBG.backgroundColor = .appOffWhite
            self.selectedTable.layoutSubviews()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.table{
            if self.selectedSubCategory.contains(self.listCatagory[indexPath.row]){
                self.selectedSubCategory.removeObject(object: self.listCatagory[indexPath.row])
            }else{
                if isFromProfile{
                    if (self.selectedSubCategory.count+self.previousSubCategory.count) >= self.object.max_selection_allowed{return}
                }
                self.selectedSubCategory.append(self.listCatagory[indexPath.row])
            }
        }else{
            
        }
        
        self.table.reloadData()
        if self.selectedSubCategory.count > 0{
            self.btnNext.setTitleColor(.white, for: .normal)
            self.btnNext.backgroundColor = .appRed
        }else{
            self.btnNext.setTitleColor(.appOffGray, for: .normal)
            self.btnNext.backgroundColor = .appOffWhite
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let strUpdate = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.listCatagory = self.object.children.filter({ (model) -> Bool in
            return model.name.lowercased().hasPrefix(strUpdate.lowercased())
        })
        self.table.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class TelentTableCell:UITableViewCell{
    @IBOutlet var lblSkill:AGLabel!
    @IBOutlet var btnSelect:AGButton!
    @IBOutlet var viewBG:AGView!
    var object:SubCategoryModel = SubCategoryModel()
    
    override func awakeFromNib() {
       
    }
    func setupData(model:SubCategoryModel){
        self.object = model
        self.lblSkill.text = self.object.name
    }
}

