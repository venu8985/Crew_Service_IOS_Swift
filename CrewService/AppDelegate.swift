//
//  AppDelegate.swift
//  iOSTemplate
//
//  Created by Gaurav Gudaliya R on 30/12/19.
//  Copyright © 2019 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import SwiftyJSON
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shortcutItemToProcess: UIApplicationShortcutItem?
    var backgroundSessionCompletionHandler : (() -> Void)?
    var alertView = AGAlertBuilder()
    var notification : UNNotification?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.registerForRemoteNotifications(application: application)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        let backImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        if UserDetails.shared.langauge == "en"{
            Bundle.setLanguage("en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else{
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = Language.get("Cancel")
        IQKeyboardManager.shared.toolbarManageBehaviour = .byPosition
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
        CommonAPI.shared.internalsettings(parameters: [:]) { data in
        }
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? UNNotification {
            notification = shortcutItem
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }
    func applicationWillResignActive(_ application: UIApplication) {
       
//        if UserDetails.isUserLogin{
//             application.shortcutItems = [UIApplicationShortcutItem(type: "AddProduct",
//             localizedTitle: Language.get("Add Product"),
//             localizedSubtitle: nil,
//             icon: UIApplicationShortcutIcon(type: .add),
//             userInfo: nil),UIApplicationShortcutItem(type: "Profile",
//             localizedTitle: Language.get("Profile"),
//             localizedSubtitle: nil,
//             icon: UIApplicationShortcutIcon(type: .contact),
//             userInfo: nil),UIApplicationShortcutItem(type: "EditProfile",
//             localizedTitle: Language.get("Edit Profile"),
//             localizedSubtitle: nil,
//             icon: UIApplicationShortcutIcon(type: .compose),
//             userInfo: nil)]
//         }else{
//           application.shortcutItems = []
//       }
    }
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
           // Alternatively, a shortcut item may be passed in through this delegate method if the app was
           // still in memory when the Home screen quick action was used. Again, store it for processing.
           shortcutItemToProcess = shortcutItem
       }

    func applicationDidBecomeActive(_ application: UIApplication) {
        CommonAPI.shared.getprofile(parameters: [:]) { data in
            let t = data
            UserDetails.shared.convert(dataWith: t)
            UserDetails.shared.saveToUserDefault()
            if UserDetails.shared.profile_status == "Pending" && UserDetails.shared.activate_trial == 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.topViewController()?.present(vc, animated: true)
            }else if UserDetails.shared.activate_trial == 1 && UserDetails.shared.payment_status == "Pending",let t = UserDetails.shared.expired_at.toLocalDate(format: .sendDate)?.toAgeDays(),t <= 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.topViewController()?.present(vc, animated: true)
            }
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    func pushViewController(VC:UIViewController,animated: Bool){
        topViewController()?.navigationController?.pushViewController(VC, animated: animated)
        
    }
    func present(VC:UIViewController,animated: Bool, completion1: (() -> Void)? = nil){
        topViewController()?.navigationController?.present(VC, animated: animated, completion: {
            if let com = completion1{
                com()
            }
        })
    }
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        debugPrint(base as Any)
        return base
    }
    func openSettingForApp(){
        if let appUrl = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appUrl)
            } else {
                UIApplication.shared.openURL(appUrl)
            }
        }
    }
    func SetTabBarMainView(){

        if UserDetails.shared.langauge == "en"{
            Bundle.setLanguage("en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else{
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = AGString.done.local
        if UserDetails.shared.is_returner == 0 && UserDetails.isUserLogin{
            let vc = UIStoryboard.instantiateViewController(withViewClass: SetupProfileViewController.self)
            let nav = UINavigationController(rootViewController: vc)
            nav.setupWhiteTintColor()
            nav.navigationBar.shadowImage = UIImage()
            window?.rootViewController = nav
        }else if  UserDetails.shared.totalProfiles == 0{
            let vc = UIStoryboard.instantiateViewController(withViewClass: SkillListViewController.self)
            let nav = UINavigationController(rootViewController: vc)
            nav.setupWhiteTintColor()
            nav.navigationBar.shadowImage = UIImage()
            window?.rootViewController = nav
        }
        else{
            let vc = UIStoryboard.instantiateViewController(withViewClass: MainTabViewController.self)
            let nav = UINavigationController(rootViewController: vc)
            nav.setupWhiteTintColor()
            nav.isNavigationBarHidden = true
            window?.rootViewController = nav
        }
    }
}
