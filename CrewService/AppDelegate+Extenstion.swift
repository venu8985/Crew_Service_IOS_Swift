

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

// [START ios_10_message_handling]
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        self.notification = response.notification
        if topViewController()?.navigationController != nil{
            checkNotification()
        }
        debugPrint(userInfo)
        completionHandler()
    }
    @objc func checkNotification(){
        if UserDetails.shared.profile_status == "Pending" && UserDetails.shared.activate_trial == 0{
            let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            topViewController()?.present(vc, animated: true)
            return
        }else if UserDetails.shared.activate_trial == 1 && UserDetails.shared.payment_status == "Pending",let t = UserDetails.shared.expired_at.toLocalDate(format: .sendDate)?.toAgeDays(),t <= 0{
            let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            topViewController()?.present(vc, animated: true)
            return
        }
        if let shortcutItem = AppDelegate.shared.notification{
            AppDelegate.shared.notification = nil
            let notify_type = (shortcutItem.request.content.userInfo["notify_type"] as? String ?? "")
            //            'admin','Verified','projectCancelled','projectCompleted','contractReceived','shootingPlanCreated','shootingPlanRevised','auditionRequestReceived','hireAgency','proposalSubmitted','projectAwarded','contractAccepted','contractRejected','milestonePaymentReleased','milestonePaymentNotReceived','hireRequestAccepted','hireRequestRejected','milestonePaymentReceived','milestonePaymentReminder','shootingPlanReschedule','auditionRequestAccepted','auditionRequestRejected'
            if notify_type == "auditionRequestReceived"{
                let vc = UIStoryboard.instantiateViewController(withViewClass: AuditionViewController.self)
                AppDelegate.shared.pushViewController(VC: vc, animated: true)
            }
            else if notify_type == "contractReceived"{
                var request:Booking = Booking()
                CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:(shortcutItem.request.content.userInfo["value"] as? String ?? "")]) { data in
                    request <= data
                    let vc = UIStoryboard.instantiateViewController(withViewClass: RequestDetailViewController.self)
                    vc.request = request
                    AppDelegate.shared.pushViewController(VC: vc, animated: true)
                }
            }
            else if notify_type == "hireAgency"{
                var request:Booking = Booking()
                CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:(shortcutItem.request.content.userInfo["value"] as? String ?? "")]) { data in
                    request <= data
                    let vc = UIStoryboard.instantiateViewController(withViewClass: RequestDetailViewController.self)
                    vc.request = request
                    AppDelegate.shared.pushViewController(VC: vc, animated: true)
                }
            }
            else if notify_type == "milestonePaymentReleased"{
                var request:Booking = Booking()
                CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:(shortcutItem.request.content.userInfo["value"] as? String ?? "")]) { data in
                    request <= data
                    let vc = UIStoryboard.instantiateViewController(withViewClass: MileStoneViewController.self)
                    vc.request = request
                    AppDelegate.shared.pushViewController(VC: vc, animated: true)
                }
            }
            else if notify_type == "shootingPlanCreated"{
                let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabViewController.self)
                 VC.selectedIndex = 2
                 AppDelegate.shared.window?.rootViewController = VC
            }
        }
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let notify_type = (notification.request.content.userInfo["notify_type"] as? String ?? "")
        if notify_type == "Verified" || notify_type == "Rejected"{
            NotificationCenter.default.post(name: NSNotification.Name("Verified"), object: nil)
        }
        completionHandler([.alert, .sound])
    }
    
    //MARK:- Register for push notification.
    func registerForRemoteNotifications(application: UIApplication) {
        debugPrint("Registering for Push Notification...")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions, completionHandler: { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async(execute: {
                            application.registerForRemoteNotifications()
                        })
                    } else {
                        debugPrint("Error Occurred while registering for push \(String(describing: error?.localizedDescription))")
                    }
                })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        self.updateFcmToken()
    }
    func updateFcmToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                UserDetails.shared.fcm_id = token
                if UserDetails.isUserLogin{
                    CommonAPI.shared.updatefcmtoken(parameters: [CWeb.fcm_id:UserDetails.shared.fcm_id]) { _ in
                        
                    }
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken{
            UserDetails.shared.fcm_id = token
            if UserDetails.isUserLogin{
                CommonAPI.shared.updatefcmtoken(parameters: [CWeb.fcm_id:UserDetails.shared.fcm_id]) { _ in
                    
                }
            }
        }
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        let localNotification = UNMutableNotificationContent()
        localNotification.sound = UNNotificationSound.default
        
        debugPrint("userInfo",userInfo)
        if let extraData = userInfo["extraData"] {
            if extraData is String {
                if let data = (extraData as! String).data(using: .utf8) {
                    do {
                        if let extraDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]{
                            if UserDetails.shared.langauge == "ar"
                            {
                                localNotification.title = extraDic["title"] as? String ?? ""
                                localNotification.body = extraDic["description"] as? String  ?? ""
                            }
                            else
                            {
                                localNotification.title = extraDic["en_title"] as? String  ?? ""
                                localNotification.body =  extraDic["en_description"] as? String  ?? ""
                            }
                            localNotification.userInfo = extraDic
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                            let request = UNNotificationRequest(identifier: "TempPush_\(NSDate().timeIntervalSince1970 * 1000)", content: localNotification, trigger: trigger)
                            let center = UNUserNotificationCenter.current()
                            center.add(request, withCompletionHandler: { error in
                            })
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension UIViewController{
    
    func addSkipButton(){
        let customButton = AGButton(type: UIButton.ButtonType.custom)
        //customButton.frame = CGRect(x: 0, y: 0, width: 90.0, height: 30.0)
        customButton.setTitle(Language.get("SKIP"), for: .normal)
        customButton.setImage(UIImage(named: "skip"), for: .normal)
        customButton.titleLabel?.font = UIFont.init(name: "AvenirLTStd-Black", size: 12.0) ?? UIFont.boldSystemFont(ofSize: 12)
        customButton.cornerRadius = 5
        customButton.setTitleColor(.black, for: .normal)
        customButton.backgroundColor = UIColor(hex: 0xEEEEEE)
        customButton.addTarget(self, action: #selector(self.OpenHomeScreen), for: .touchUpInside)
        customButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: customButton), animated: true)
    }
    @objc func OpenHomeScreen(){
        AppDelegate.shared.SetTabBarMainView()
    }
    @objc func btnOpenMenu(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        vc?.view.backgroundColor = .clear
        self.present(vc!, animated: false) {
            UIView.animate(withDuration: 0.5) {
                vc?.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
            }
        }
    }
    @objc func OpenReviewPopupScreen(){
        if UserDetails.shared.profile_status != "Verified"{
            let vc = UIStoryboard.instantiateViewController(withViewClass: ReviewPopupVC.self)
            vc.modalPresentationStyle = .overFullScreen
            AppDelegate.shared.present(VC: vc, animated: true)
            return
        }
    }
    
    @objc func btnNotication(){
        let vc = UIStoryboard.instantiateViewController(withViewClass: NotificationViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func replaceViewController(controller:UIViewController){
        if var arr = self.navigationController?.viewControllers{
            for i in 0..<arr.count {
                if arr[i].isKind(of: controller.classForCoder) {
                    arr.remove(at: i)
                    arr.insert(controller, at: i)
                    self.navigationController?.setViewControllers(arr, animated: false)
                    break
                }
            }
        }
    }
    func openHomeScreen(){
        if let count = self.navigationController?.viewControllers.count {
            self.navigationController?.viewControllers.remove(at: count-1)
        }
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storybaord.instantiateInitialViewController()
    }
    func displayAlertMsg(string:String){
        UIApplication.shared.keyWindow?.makeToast(string)
    }
    func displaySuccessMsg(string:String){
        UIApplication.shared.keyWindow?.makeToast(string)
    }
    func displayAPIFalseError(string:String){
        UIApplication.shared.keyWindow?.makeToast(string)
    }
}
extension UIImageView{
    func setImage(url:String,placeholderImage:UIImage = UIImage(named: "logo")!){
        self.sd_setImage(with: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url), placeholderImage: placeholderImage, options: [], progress: nil, completed: nil)
    }
}

extension UIView {
    
    func applyGradient(colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.accessibilityLabel = "gaurav"
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true
    }
    func removeGradient(){
        for t in layer.sublayers ?? []{
            if t.accessibilityLabel == "gaurav"{
                t.removeFromSuperlayer()
            }
        }
    }
}
extension UINavigationController{
    func setupWhiteTintColor(){
           self.isNavigationBarHidden = false
           if #available(iOS 13.0, *) {
               let appearance = UINavigationBarAppearance()
               appearance.configureWithDefaultBackground()
               appearance.backgroundColor = UIColor.white
               appearance.shadowColor = UIColor.clear
               appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
               navigationBar.standardAppearance = appearance;
               navigationBar.scrollEdgeAppearance = appearance;
               navigationBar.compactAppearance = appearance;
            //   navigationBar.barStyle = UIBarStyle.black;
               navigationBar.tintColor = UIColor.black
               navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
              // navigationBar.barStyle = UIBarStyle.default;
               navigationBar.shadowImage = UIImage()
               navigationBar.backIndicatorImage = UIImage(named: "back")
               navigationBar.backIndicatorTransitionMaskImage =  UIImage(named: "back")
               if #available(iOS 14.0, *) {
                   self.navigationItem.backButtonDisplayMode = .minimal
               }
               
           } else {
               self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
               let backImage = UIImage(named: "back")
               self.navigationBar.backIndicatorImage = backImage
               self.navigationBar.backIndicatorTransitionMaskImage = backImage
               
               self.navigationBar.tintColor = UIColor.black
               self.navigationBar.barTintColor = UIColor.white
               self.navigationBar.isTranslucent = false
               self.navigationBar.setBackgroundImage(UIImage(), for: .default)
               //   self.navigationBar.shadowImage = UIImage()
               self.navigationBar.barStyle = UIBarStyle.default;
               UIView.animate(withDuration: 0.3) {
                   self.setNeedsStatusBarAppearanceUpdate()
               }
               
               //self.navigationBar.barStyle = UIBarStyle.black;
           }
       }
    func setupBlackTintColor(){
        
        self.isNavigationBarHidden = false
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = UIColor.clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
            navigationBar.standardAppearance = appearance;
            navigationBar.scrollEdgeAppearance = appearance;
            navigationBar.compactAppearance = appearance;
         //   navigationBar.barStyle = UIBarStyle.black;
            navigationBar.tintColor = UIColor.black
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
           // navigationBar.barStyle = UIBarStyle.default;
            navigationBar.shadowImage = UIImage()
            navigationBar.backIndicatorImage = UIImage(named: "back")
            navigationBar.backIndicatorTransitionMaskImage =  UIImage(named: "back")
            if #available(iOS 14.0, *) {
                self.navigationItem.backButtonDisplayMode = .minimal
            }
            
        } else {
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
            let backImage = UIImage(named: "back")
            self.navigationBar.backIndicatorImage = backImage
            self.navigationBar.backIndicatorTransitionMaskImage = backImage
            
            self.navigationBar.tintColor = UIColor.black
            self.navigationBar.barTintColor = UIColor.white
            self.navigationBar.isTranslucent = false
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            //   self.navigationBar.shadowImage = UIImage()
            self.navigationBar.barStyle = UIBarStyle.default;
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            //self.navigationBar.barStyle = UIBarStyle.black;
        }
    }
}
extension UISegmentedControl {
    /// Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            //            let tintColorImage = UIImage(color: .white,size: self.frame.size)
            //            // Must set the background image for normal to something (even clear) else the rest won't work
            //            setBackgroundImage(UIImage(color: .white,size: self.frame.size), for: .normal, barMetrics: .default)
            //            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            //            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            // setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderColor = tintColor.cgColor
            layer.cornerRadius = 10
        }
    }
}
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(data: image.pngData()!)!
    }
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        newSize = CGSize(width: targetSize.width,  height: targetSize.height)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}




