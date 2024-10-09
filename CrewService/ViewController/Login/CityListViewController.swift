//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    var arrCityList:[CityModel] = []
    var arrAllCityList:[CityModel] = []
    var completetion:((CityModel)->Void)?
    var isCountrySelection = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.tintColor = UIColor.black
        self.tableView.reloadData()
        self.arrCityList = self.arrAllCityList
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
        return self.arrCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.lblName.text =  self.arrCityList[indexPath.row].name
        if UserDetails.shared.langauge != "en"{
            cell.lblName.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.completetion!(self.arrCityList[indexPath.row])
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            searchBar.resignFirstResponder()
            return true
        }
        let strUpdated = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        self.arrCityList = self.arrAllCityList.filter({ (modal) -> Bool in
            return modal.name.contains(strUpdated) || modal.name.description.contains(strUpdated)
        })
        if strUpdated == ""{
             self.arrCityList = self.arrAllCityList
        }
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.dismiss(animated: true) {
            
        }
    }
}
class CityCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
}
