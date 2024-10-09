//
//  CommonAPI.swift
//  Mishkat
//
//  Created by Gaurav Gudaliya R on 04/02/19.
//  Copyright © 2019 Mishkat. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class CommonAPI: UIViewController {
    static var shared = CommonAPI()
    
    var timer:Timer = Timer()
    var token_expire_time: Double {
        get { return UserDefaults.standard.double(forKey: "token_expire_time") }
        set {
            UserDefaults.standard.set(newValue, forKey: "token_expire_time")
            self.StartTokenTime()
        }
    }
    func setExpriedTime(values:Int,type:String){
        var value:Int = values
        var component: Calendar.Component = .second
        if type == "Seconds"{
            component = .second
            value = value - 10
        }else if type == "Minutes"{
            component = .minute
        }else if type == "Hours"{
            component = .hour
        }else if type == "Days"{
            component = .day
        }else if type == "Months"{
            component = .month
        }else if type == "Years"{
            component = .year
        }
        token_expire_time = Calendar.current.date(byAdding: component, value: value, to: Date())!.timeIntervalSince1970
    }
    func getExpriedTime()->Date{
        debugPrint("Token Expried Time:",Date(timeIntervalSince1970: token_expire_time))
        debugPrint("CurrentTime:",Date())
        return Date(timeIntervalSince1970: token_expire_time)
    }
    func StartTokenTime(){
        timer.invalidate()
        timer = Timer(fireAt: CommonAPI.shared.getExpriedTime(), interval: 0, target: self, selector: #selector(RefreshTokenCode), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    @objc func RefreshTokenCode(){
        CommonAPI.shared.refreshtoken(parameters: [:]) { data in
        }
    }
    func CheckTokenIsExpriedOrNot(completionHandler: @escaping () -> Void){
        if CommonAPI.shared.getExpriedTime() <= Date() && UserDetails.isUserLogin{
            CommonAPI.shared.refreshtoken(parameters: [:]) { data in
                completionHandler()
            }
        }else{
            if UserDetails.isUserLogin{
                self.StartTokenTime()
            }
            completionHandler()
        }
    }
    var arrCountryList:[CountryModel] = []
    var arrCityList:[CityModel] = []
    func refreshtoken(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        func loginView(){
            UserDetails.isUserLogin = false
            let login = UIStoryboard.instantiateViewController(withViewClass: SplashScreenController.self)
            let navi = UINavigationController(rootViewController: login)
            AppDelegate.shared.window?.rootViewController = navi
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
        GGWebServices(postRequest: .refreshtoken, parameters: parameters)
            .responseJSON(isShow:false) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            UserDetails.shared.authToken = data["access_token"] as! String
                            CommonAPI.shared.setExpriedTime(values:data["expires_in"] as? Int ?? 3600,type:data["expires_unit"] as? String ?? "Seconds")
                            UserDetails.shared.saveToUserDefault()
                            completionHandler(data)
                        }else{
                            loginView()
                        }
                    }
                    break
                case .failer( _):
                    loginView()
                    break
                }
        }
    }
    func login(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void,errorHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .login, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func country(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        if UserDetails.shared.arrCountry.count != 0 {
            self.arrCountryList = UserDetails.shared.arrCountry
            completionHandler([:])
            return
        }
        GGWebServices(postRequest: .country, parameters: parameters)
            .responseJSON(isShow:true) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        self.arrCountryList = []
                        if let data = json["data"] as? [[String: AnyObject]] {
                            var temp:[CountryModel] = []
                            temp <= data
                            for t in temp {
                                self.arrCountryList.append(t)
                            }
                            UserDetails.shared.arrCountry = self.arrCountryList
                            completionHandler([:])
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func city(parameters:GGParameters,completionHandler: @escaping ([CityModel]) -> Void){
        GGWebServices(postRequest: .city, parameters: parameters)
            .responseJSON(isShow:true) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        if let data = json["data"] as? [[String: AnyObject]] {
                            var temp:[CityModel] = []
                            temp <= data
                            completionHandler(temp)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func resendotp(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .resendotp, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func verifyotp(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .verifyotp, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func updatefcmtoken(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .updatefcmtoken, parameters: parameters)
            .responseJSON(isShow:false) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func logout(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .logout, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func completeprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .completeprofile, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func getprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .getprofile, parameters: parameters)
            .responseJSON(isShow:false) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func updateprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .updateprofile, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func updateprofileimage(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(uploadRequest: .updateprofileimage, parameters: parameters,method: .post)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func changepassword(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .changepassword, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func notifications(parameters:GGParameters,completionHandler: @escaping ([[String: AnyObject]]) -> Void){
        GGWebServices(postRequest: .notifications, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [[String: AnyObject]] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func deletenotification(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(deleteRequest: .deletenotification, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func appsettings(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .appsettings, parameters: parameters)
            .responseJSON(isShow:false) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func submitfeedback(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .submitfeedback, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func aboutus(parameters:GGParameters,isShow:Bool = true,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .aboutus, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case internalsettings
    func internalsettings(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .internalsettings, parameters: parameters)
            .responseJSON(isShow:false) { (result) in
                switch result {
                case .success(let jsonRes, _):
                    if result.isSuccess{
                        let json = JSON(jsonRes)
                        AWSUpload.shared.AWSkey = json["data"]["AWS_ACCESS_KEY_ID"].stringValue
                        AWSUpload.shared.AWSsecret = json["data"]["AWS_SECRET_ACCESS_KEY"].stringValue
                        AWSUpload.shared.AWSbucket = json["data"]["AWS_BUCKET"].stringValue
                        AWSUpload.shared.AWSregion = json["data"]["AWS_DEFAULT_REGION"].stringValue
                        AWSUpload.shared.AWSurl = json["data"]["AWS_URL"].stringValue
                        AWSUpload.shared.setupAWS()
                        print(json)
                        if let data = jsonRes.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case termsconditions
    func termsconditions(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .termsconditions, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case productdetail
    func privacypolicy(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .privacypolicy, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case deleteproduct
    func updatesignature(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(uploadRequest: .updatesignature, parameters: parameters, method: .post)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case category
    func category(parameters:GGParameters,completionHandler: @escaping ([[String: AnyObject]]) -> Void){
        GGWebServices(postRequest: .category, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [[String: AnyObject]] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case addprofile
    func addprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .addprofile, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case editprofile
    func editprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .editprofile, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case deleteprofile
    func deleteprofile(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(deleteRequest: .deleteprofile, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case forgotpassword
    func forgotpassword(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .forgotpassword, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case verifyforgotpasswordotp
    func verifyforgotpasswordotp(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .verifyforgotpasswordotp, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case updatenewpassword
    func updatenewpassword(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .updatenewpassword, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case completeprofilewithoutpassword
    func completeprofilewithoutpassword(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .completeprofilewithoutpassword, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        //                              if let data = json.object(forKey: "data") as? [String: AnyObject] {
                        //                                  completionHandler(data)
                        //                              }
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case hireresourcerequests
    func hireresourcerequests(parameters:GGParameters,isShow:Bool=true,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourcerequests, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case hireresourcerequestdetails
    func hireresourcerequestdetails(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourcerequestdetails, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case hireresourceacceptrequest
    func hireresourceacceptrequest(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourceacceptrequest, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    //    case hireresourcerejectrequest
    func hireresourcerejectrequest(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourcerejectrequest, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
  

//    case orderlistings
    func hireresourceacceptcontract(parameters:GGParameters,isShow:Bool=true,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourceacceptcontract, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
//    case orderdetail
    func hireresourcerejectcontract(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .hireresourcerejectcontract, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
//    case cancelquestions
    func milestonepaymentreceived(parameters:GGParameters,completionHandler: @escaping ([[String: AnyObject]]) -> Void){
        GGWebServices(postRequest: .milestonepaymentreceived, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [[String: AnyObject]] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
//    case cancelorder
    func milestonepaymentnotreceived(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .milestonepaymentnotreceived, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
//    case confirmorder
    func milestonepaymentreminder(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .milestonepaymentreminder, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                         completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
//    case shippedorder
    func shootingplans(parameters:GGParameters,isShow:Bool=true,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .shootingplans, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func rescheduleshootingplan(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .rescheduleshootingplan, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    
//    case changestatus
    func auditions(parameters:GGParameters,isShow:Bool=false,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .auditions, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    
//    case getfaq
    func acceptaudition(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(postRequest: .acceptaudition, parameters: parameters)
            .responseJSON { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        if let data = json.object(forKey: "data") as? [String: AnyObject] {
                            completionHandler(data)
                        }
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func rejectaudition(parameters:GGParameters,completionHandler: @escaping ([String: AnyObject]) -> Void){
         GGWebServices(postRequest: .rejectaudition, parameters: parameters)
             .responseJSON { (result) in
                 switch result {
                 case .success(let json, _):
                     if result.isSuccess{
                         print(json)
                         if let data = json.object(forKey: "data") as? [String: AnyObject] {
                             completionHandler(data)
                         }
                     }
                     break
                 case .failer(let error):
                     self.displayAPIFalseError(string: error.alertMessage)
                     break
                 }
         }
     }
     func getcalenderdata(parameters:GGParameters,isShow:Bool = true,completionHandler: @escaping ([String: AnyObject]) -> Void){
         GGWebServices(postRequest: .getcalenderdata, parameters: parameters)
             .responseJSON(isShow:isShow) { (result) in
                 switch result {
                 case .success(let json, _):
                     if result.isSuccess{
                         print(json)
                         if let data = json.object(forKey: "data") as? [String: AnyObject] {
                             completionHandler(data)
                         }
                     }
                     break
                 case .failer(let error):
                     self.displayAPIFalseError(string: error.alertMessage)
                     break
                 }
         }
     }
    func deletebusyslot(parameters:GGParameters,isShow:Bool = true,completionHandler: @escaping ([String: AnyObject]) -> Void){
        GGWebServices(deleteRequest: .deletebusyslot, parameters: parameters)
            .responseJSON(isShow:isShow) { (result) in
                switch result {
                case .success(let json, _):
                    if result.isSuccess{
                        print(json)
                        completionHandler([:])
                    }
                    break
                case .failer(let error):
                    self.displayAPIFalseError(string: error.alertMessage)
                    break
                }
        }
    }
    func addbusyslot(parameters:GGParameters,isShow:Bool = true,completionHandler: @escaping ([String: AnyObject]) -> Void){
         GGWebServices(uploadRequest: .addbusyslot, parameters: parameters,method: .post)
             .responseJSON(isShow:isShow) { (result) in
                 switch result {
                 case .success(let json, _):
                     if result.isSuccess{
                         print(json)
                         if let data = json.object(forKey: "data") as? [String: AnyObject] {
                             completionHandler(data)
                         }
                     }
                     break
                 case .failer(let error):
                     self.displayAPIFalseError(string: error.alertMessage)
                     break
                 }
         }
     }
    func nationality(parameters:GGParameters,isShow:Bool = true,completionHandler: @escaping ([[String: AnyObject]]) -> Void){
         GGWebServices(uploadRequest: .nationality, parameters: parameters,method: .post)
             .responseJSON(isShow:isShow) { (result) in
                 switch result {
                 case .success(let json, _):
                     if result.isSuccess{
                         print(json)
                         if let data = json.object(forKey: "data") as? [[String: AnyObject]] {
                             completionHandler(data)
                         }
                     }
                     break
                 case .failer(let error):
                     self.displayAPIFalseError(string: error.alertMessage)
                     break
                 }
         }
     }
}
