//
//  MainTabViewController.swift
//  TasmemcomUser
//
//  Created by Gaurav Gudaliya R on 30/06/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    let acceptVC = UIStoryboard.instantiateViewController(withViewClass: ApplicationSubmitVC1.self)
    let rejectVC = UIStoryboard.instantiateViewController(withViewClass: ApplicationRejectVC.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared.checkNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserProfile), name: NSNotification.Name("Verified"), object: nil)
        self.getUserProfile()
        CommonAPI.shared.appsettings(parameters: [:], completionHandler: { data in
            if let tt =  data["version"] as? String,(Float(Application.appVersion) ?? 0.0) < (Float(tt) ?? 0.0){
                let vc = UIStoryboard.instantiateViewController(withViewClass: UpdateVersionViewController.self)
                vc.version = tt
                vc.comment =  data["update_description"] as? String ?? ""
                vc.modalPresentationStyle = .fullScreen
                AppDelegate.shared.present(VC: vc, animated: true)
                
            }else{
                if let tt = data["version"] as? String,(Float(Application.appVersion) ?? 0.0) > (Float(tt) ?? 0.0){
                    CheckAppUpdateModel.shared.checkAppUpdate { (model) in
                        if model.updateType != .unknown{
                            let vc = UIStoryboard.instantiateViewController(withViewClass: UpdateVersionViewController.self)
                            vc.comment =  data["update_description"] as? String ?? ""
                            vc.version = tt
                            vc.modelVersion = model
                            vc.modalPresentationStyle = .fullScreen
                            AppDelegate.shared.present(VC: vc, animated: true)
                        }
                    } completetionErrorHandler: { (error) in
                        debugPrint(error)
                    }
                }
            }
         })
        
        CommonAPI.shared.country(parameters: [:]) { data in
            
        }
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.items![0].title = Language.get("Home")
        self.tabBar.items![1].title = Language.get("My Availability")
        self.tabBar.items![2].title = Language.get("Shooting Plan")
        self.tabBar.items![3].title = Language.get("Profile")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @objc func getUserProfile(){
        CommonAPI.shared.getprofile(parameters: [:]) { data in
            let t = data
            UserDetails.shared.convert(dataWith: t)
            UserDetails.shared.saveToUserDefault()
            if UserDetails.shared.profile_status == "Pending" && UserDetails.shared.activate_trial == 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }else if UserDetails.shared.activate_trial == 1 && UserDetails.shared.payment_status == "Pending",let t = UserDetails.shared.expired_at.toLocalDate(format: .sendDate)?.toAgeDays(),t <= 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            else{
                if UserDetails.shared.profile_status != "Verified"{
                    self.OpenReviewPopupScreen()
                    return
                }
            }
            self.setupLayout()
        }
    }
    func setupLayout(){
        acceptVC.dismiss(animated: false, completion:nil)
        rejectVC.dismiss(animated: false, completion:nil)
        if UserDetails.shared.profile_status == "Pending"{
//            acceptVC.modalPresentationStyle = .overFullScreen
//            self.present(acceptVC, animated: false, completion: nil)
        }else if UserDetails.shared.profile_status == "Processing"{
//            acceptVC.modalPresentationStyle = .overFullScreen
//            self.present(acceptVC, animated: false, completion: nil)
        }else if UserDetails.shared.profile_status == "Verified"{
//            acceptVC.modalPresentationStyle = .overFullScreen
//            self.present(acceptVC, animated: false, completion: nil)
        }else if UserDetails.shared.profile_status == "Rejected"{
            rejectVC.modalPresentationStyle = .overFullScreen
            self.present(rejectVC, animated: false, completion: nil)
        }else{
            acceptVC.dismiss(animated: false, completion:nil)
            rejectVC.dismiss(animated: false, completion:nil)
        }
    }
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: #selector(btnOpenMenu)), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "notification_2"), style: .done, target: self, action: #selector(btnNotication)), animated: false)
        self.navigationController?.setupWhiteTintColor()
    }
}
