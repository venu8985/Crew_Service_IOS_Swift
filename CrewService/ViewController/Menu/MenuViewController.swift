//
//  MenuViewController.swift
//  CoffePower
//
//  Created by Gaurav Gudaliya R on 21/04/19.
//  Copyright © 2019 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import StoreKit
import IQKeyboardManagerSwift
import SafariServices

class MenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var img:AGImageView!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblGotoProfile:UILabel!
    @IBOutlet var menuView:UIView!
    @IBOutlet var btnProfile:AGButton!
    @IBOutlet var lblVersionName:UILabel!
    
    var icons = ["Audition_Request","language-1","notification_2-1","share_app-1","support-1","trems_of_service","Privacy-1","change_password","logout-1"]
    var strText = ["Audition Requests","ARABIC","Notifications","Share App","Support","Terms of Service","Privacy Policy","Change Password","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblVersionName.text =  Language.get("Version:")+" "+Application.appVersion + " (\(Application.appBuild))"
        if UserDetails.shared.langauge == "ar"{
            if let index = self.strText.indexOfObject(x: "ARABIC"){
                self.strText.removeObject(object: "ARABIC")
                self.strText.insert("ENGLISH", at: index)
            }
            icons = ["Audition_Request","language-1","notification_2-1","share_app-1","support-1","trems_of_service","Privacy-1","change_password","logout-2"]
        }else{
            if let index = self.strText.indexOfObject(x: "ENGLISH"){
                self.strText.removeObject(object: "ENGLISH")
                self.strText.insert("ARABIC", at: index)
            }
            icons = ["Audition_Request","language-1","notification_2-1","share_app-1","support-1","trems_of_service","Privacy-1","change_password","logout-1"]
        }
      
        self.btnProfile.action = {
            if UserDetails.isUserLogin{
                self.dismiss(animated: false) {
                    let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabViewController.self)
                    VC.selectedIndex = 3
                    AppDelegate.shared.window?.rootViewController = VC
                }
            }else{
                self.dismiss(animated: false) {
                    let VC = UIStoryboard.instantiateViewController(withViewClass: LoginViewController.self)
                    AppDelegate.shared.present(VC: VC, animated: true)
                }
            }
        }
        self.tableView.reloadData()
        if UserDetails.shared.langauge == "ar"{
            self.menuView.frame = CGRect(x: self.view.frame.width+self.menuView.frame.width, y: self.menuView.frame.origin.y, width: self.menuView.frame.width, height: self.menuView.frame.height)
        }else{
            self.menuView.frame = CGRect(x: -self.menuView.frame.width, y: self.menuView.frame.origin.y, width: self.menuView.frame.width, height: self.menuView.frame.height)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDetails.shared.langauge == "ar"{
            self.menuView.frame = CGRect(x: self.view.frame.width+self.menuView.frame.width, y: self.menuView.frame.origin.y, width: self.menuView.frame.width, height: self.menuView.frame.height)
        }else{
            self.menuView.frame = CGRect(x: -self.menuView.frame.width, y: self.menuView.frame.origin.y, width: self.menuView.frame.width, height: self.menuView.frame.height)
        }
        UIView.animate(withDuration: 0.5) {
            self.menuView.frame = CGRect(x: 0, y: self.menuView.frame.origin.y, width: self.menuView.frame.width, height: self.menuView.frame.height)
        }
        self.img.sd_setImage(with: URL(string: UserDetails.shared.profile_image.LoadProvidersImage()), placeholderImage: UIImage(named: "user_placeholder"), options: [], progress: nil, completed: nil)
        self.lblName.text = UserDetails.shared.name
        self.lblGotoProfile.isHidden = false
        self.img.borderWidth = 0
    }
    @IBAction func btnCloseAction(_ sender:UIButton){
        self.dismiss(animated: false) {
            
        }
    }
    @objc func BtnCloseAction(){
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strText.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customeCell", for: indexPath) as! customeCell
        cell.imgIcon.image = UIImage(named: icons[indexPath.row])
        cell.lblName.text =  Language.get(strText[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strText[indexPath.row] == "Audition Requests"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: AuditionViewController.self)
                AppDelegate.shared.pushViewController(VC: VC, animated: true)
            }
        }else if strText[indexPath.row] == "Payments"{
            self.dismiss(animated: false) {
               
            }
        }
        else if strText[indexPath.row] == "ARABIC" || strText[indexPath.row] == "ENGLISH"{
            if UserDetails.shared.langauge == "en"{
                UserDetails.shared.langauge = "ar"
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                 UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = AGString.cancel.local
                self.openHomeScreen()
            }else{
                UserDetails.shared.langauge = "en"
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                 UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = AGString.cancel.local
                self.openHomeScreen()
            }
        }
        else if strText[indexPath.row] == "Support"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: ContactUsViewController.self)
                AppDelegate.shared.pushViewController(VC: VC, animated: true)
            }
        }
        else if strText[indexPath.row] == "Notifications"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: NotificationViewController.self)
                AppDelegate.shared.pushViewController(VC: VC, animated: true)
            }
        }
        else if strText[indexPath.row] == "Change Password"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: ChangePasswordViewController.self)
                AppDelegate.shared.pushViewController(VC: VC, animated: true)
            }
        }
        else if strText[indexPath.row] == "Share App"{
            self.dismiss(animated: false) {
                let items = [Language.get("This app is my favorite.Please download and try."),"https://itunes.apple.com/us/app/apple-store/id1601820293?mt=8"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                AppDelegate.shared.present(VC: ac, animated: true)
            }
        }
        else if strText[indexPath.row] == "Logout"{
            CommonAPI.shared.logout(parameters: [:]) {_ in
               
            }
            
            UserDetails.isUserLogin = false
            let ln = UserDetails.shared.langauge
            let fcm = UserDetails.shared.fcm_id
            let arrCountry = UserDetails.shared.arrCountry
            
            UserDetails.shared.clear()
            UserDetails.shared.convert(dataWith: [:])
            UserDetails.shared.langauge = ln
            UserDetails.shared.fcm_id = fcm
            UserDetails.shared.arrCountry = arrCountry
          
            self.openHomeScreen()
        }
        else if strText[indexPath.row] == "Sign In"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: LoginViewController.self)
                let navi = UINavigationController(rootViewController: VC)
                navi.modalPresentationStyle = .overFullScreen
                AppDelegate.shared.present(VC:navi, animated: true)
            }
        }
        else if strText[indexPath.row] == "Terms of Service"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: WebViewController.self)
                VC.type = .tc
                AppDelegate.shared.pushViewController(VC: VC, animated: false)

            }
        }
        else if strText[indexPath.row] == "Privacy Policy"{
            self.dismiss(animated: false) {
                let VC = UIStoryboard.instantiateViewController(withViewClass: WebViewController.self)
                VC.type = .pp
                AppDelegate.shared.pushViewController(VC: VC, animated: false)
            }
        }
    }
}
class customeCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
}

