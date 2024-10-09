//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    var arrCountryList:[CountryModel] = []
    var completetion:((CountryModel)->Void)?
    var isCountrySelection = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.tintColor = UIColor.black
        self.arrCountryList = CommonAPI.shared.arrCountryList
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        searchBar.showsCancelButton = true
        if (UserDetails.shared.langauge != "en"){if #available(iOS 13.0, *) {
            searchBar.searchTextField.textAlignment = .right
        } else {
            // Fallback on earlier versions
            }}
        self.searchBar.placeholder = Language.get("Search here...")
        if UserDetails.shared.langauge != "en"{
             tableView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    @IBAction func btnClose(_ animated: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        if isCountrySelection{
            cell.lblName.text =  self.arrCountryList[indexPath.row].local_name
        }else{
            cell.lblName.text = "+" + self.arrCountryList[indexPath.row].dial_code.description + " - " + self.arrCountryList[indexPath.row].local_name
        }
        
        cell.imgIcon.sd_setImage(with: URL(string: GGWebKey.image_country_flags_path+self.arrCountryList[indexPath.row].flag), placeholderImage: nil, options: [], progress: nil, completed: nil)
        if UserDetails.shared.langauge != "en"{
            cell.lblName.transform = CGAffineTransform(scaleX: -1, y: 1)
            cell.imgIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCountrySelection{
            self.dismiss(animated: true) {
                self.completetion!(self.arrCountryList[indexPath.row])
            }
        }else{
            UserDetails.shared.selectedCountry = self.arrCountryList[indexPath.row]
            self.dismiss(animated: true) {
                self.completetion!(self.arrCountryList[indexPath.row])
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            searchBar.resignFirstResponder()
            return true
        }
        let strUpdated = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        self.arrCountryList = CommonAPI.shared.arrCountryList.filter({ (modal) -> Bool in
            return modal.local_name.contains(strUpdated) || modal.dial_code.description.contains(strUpdated)
        })
        if strUpdated == ""{
             self.arrCountryList = CommonAPI.shared.arrCountryList
        }
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.dismiss(animated: true) {
            
        }
    }
}
class CountryCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
}
