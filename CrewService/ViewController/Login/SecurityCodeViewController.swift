//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class SecurityCodeViewController: UIViewController {
    
    @IBOutlet var btnReSendOtp:AGButton!
    @IBOutlet var viewReSendOtp:AGView!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet var btnEdit:AGButton!
    var enteredOtp: String = ""
    var mobileNo: String = ""
    
    var hash_token: String = ""
    @IBOutlet var lblText:UILabel!
    @IBOutlet var lblTime:UILabel!
    var totalTime = 120
    var countdownTimer: Timer!

    var completetion:(()->Void)?
    var user_id = ""
    
    var isForgetPassword = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblText.text = mobileNo
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        self.title = Language.get("Mobile Verification")
        viewReSendOtp.isHidden = true
        otpView.backgroundColor = UIColor.clear
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBorderColor = UIColor.lightGray
        otpView.otpFieldBorderWidth = 1
        otpView.otpFieldDefaultBackgroundColor = UIColor.clear
        otpView.otpFieldSeparatorSpace = 10
        otpView.otpFieldSize = otpView.frame.height-5
        otpView.delegate = self
        otpView.otpFieldFont = UIFont.init(name: "AvenirLTStd-Roman", size: 25.0) ?? UIFont.boldSystemFont(ofSize: 25)
        otpView.shouldAllowIntermediateEditing = true
        otpView.initializeUI()
        btnEdit.action = {
            self.navigationController?.popViewController(animated: true)
        }
        btnReSendOtp.action = {
            self.tapToReSendOTP()
            var parameters:GGParameters = [:]
            parameters[CWeb.id] = self.user_id
            parameters[CWeb.hash_token] = self.hash_token
            CommonAPI.shared.resendotp(parameters: parameters) { t in
                self.hash_token = (t["hash_token"] as! String)
                self.tapToReSendOTP()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapToReSendOTP()
    {
        countdownTimer.invalidate()
        totalTime = 120
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        btnReSendOtp.isHidden = true
    }
    @objc func updateTime() {
        self.lblTime.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            viewReSendOtp.isHidden = false
        }
    }
    func endTimer() {
        
        self.lblTime.text = ""
        countdownTimer.invalidate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endTimer()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func btnNextAction() {
        
        if enteredOtp.count != 4 {
            otpView.initializeUI()
            otpView.shake()
        }
        else{
            var parameters:GGParameters = [:]
            parameters[CWeb.otp] = enteredOtp
            parameters[CWeb.id] = user_id
            parameters[CWeb.hash_token] = self.hash_token
            parameters[CWeb.fcm_id] = UserDetails.shared.fcm_id
            if self.isForgetPassword{
                CommonAPI.shared.verifyforgotpasswordotp(parameters: parameters) { data in
                    self.endTimer()
                    let vc = UIStoryboard.instantiateViewController(withViewClass: ResetPasswordViewController.self)
                    vc.isReset = true
                    vc.user_id = self.user_id
                    vc.hash_token = (data["token"] as! String)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                CommonAPI.shared.verifyotp(parameters: parameters) { data in
                    self.endTimer()
                    UserDetails.shared.authToken = data["access_token"] as! String
                    CommonAPI.shared.setExpriedTime(values:data["expires_in"] as! Int,type:data["expires_unit"] as! String)
                    if let userDic = data["data"] as? [String: AnyObject]{
                        UserDetails.shared.user_id = (userDic["id"] as! NSNumber).description
                        UserDetails.shared.convert(dataWith: userDic)
                        UserDetails.shared.saveToUserDefault()
                    }
                    UserDetails.isUserLogin = true
                    AppDelegate.shared.SetTabBarMainView()
                }
            }
        }
    }
}
extension SecurityCodeViewController: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        return true
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        btnNextAction()
        print("OTPString: \(otpString)")
    }
}
