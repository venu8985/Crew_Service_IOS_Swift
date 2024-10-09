//
//  AWSUpload.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 22/05/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

import AWSS3
import AWSCore

class AWSUpload: NSObject {
    static var shared = AWSUpload()
    var AWSkey:String {
        get { return UserDefaults.standard.string(forKey: "AWSkey") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "AWSkey") }
    }
    var AWSsecret:String {
        get { return UserDefaults.standard.string(forKey: "AWSsecret") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "AWSsecret") }
    }
    var AWSbucket:String {
        get { return UserDefaults.standard.string(forKey: "AWSbucket") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "AWSbucket") }
    }
    var AWSregion:String {
        get { return UserDefaults.standard.string(forKey: "AWSregion") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "AWSregion") }
    }
    var AWSurl:String {
        get { return UserDefaults.standard.string(forKey: "AWSurl") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "AWSurl") }
    }
    func setupAWS(){
        let accessKey = AWSUpload.shared.AWSkey
        let secretKey = AWSUpload.shared.AWSsecret
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration.init(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        randomString = randomString + dateFormatter.string(from: Date())
        
        return randomString
    }
    func uploadFile(image: UIImage,path:String, completion: @escaping(String, String) -> Void) {
        
        let imgName = self.randomString(length: 12) + ".jpg"
        let keyname = path +  imgName
        let imageData = image.jpegData(compressionQuality: 0.3)
        
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imgName)")
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        
        let fileUrl = URL(fileURLWithPath: path)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = fileUrl
        uploadRequest.key = keyname
        uploadRequest.bucket = AWSbucket
        uploadRequest.contentType = "image/jpg"
        uploadRequest.acl = .publicRead
        let transferManager = AWSS3TransferManager.default()
        GGProgress.shared.showProgress()
        transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
            DispatchQueue.main.async(execute: {
                GGProgress.shared.hideProgress()
            })
            
            if let error = task.error {
                debugPrint("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                completion(publicURL?.absoluteString ?? keyname,imgName)
            }
            return nil
        })
        
        
        //
        //        let imgName = self.randomString(length: 12) + ".jpg"
        //        let keyname = path +  imgName
        //        let imageData = image.jpegData(compressionQuality: 0.5)
        //
        //        let expression = AWSS3TransferUtilityUploadExpression()
        //        expression.setValue("public", forRequestParameter: "acl")
        //        expression.progressBlock = { (task, progress) in
        //            DispatchQueue.main.async(execute: {
        //                debugPrint(progress)
        //            })
        //        }
        //
        //        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        //        completionHandler = { (task, error) -> Void in
        //            DispatchQueue.main.async(execute: {
        //                GGProgress.shared.hideProgress()
        //                debugPrint(task.progress)
        //                debugPrint(task)
        //                // Do something e.g. Alert a user for transfer completion.
        //                // On failed uploads, `error` contains the error object.
        //            })
        //        }
        //
        //        GGProgress.shared.showProgress()
        //        let transferUtility = AWSS3TransferUtility.default()
        //        transferUtility.uploadData(imageData!, bucket: AWSbucket, key: keyname, contentType: "image/jpg", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
        //            GGProgress.shared.hideProgress()
        //            if let error = task.error {
        //                print("Error : \(error.localizedDescription)")
        //            }
        //
        //            if task.result != nil {
        //                let url = AWSS3.default().configuration.endpoint.url
        //                let publicURL = url?.appendingPathComponent(self.AWSbucket).appendingPathComponent(keyname)
        //                if let absoluteString = publicURL?.absoluteString {
        //                    // Set image with URL
        //                    print("Image URL : ",absoluteString)
        //                }
        //                completion(publicURL?.absoluteString ?? keyname,imgName)
        //            }
        //
        //            return nil
        //        }
    }
    func uploadFileWithURL(url: URL,path:String,contentType:String, completion: @escaping(String, String) -> Void) {
        
        let imgName = self.randomString(length: 12) + ".mp4"
        let keyname = path +  imgName
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = url
        uploadRequest.key = keyname
        uploadRequest.bucket = AWSbucket
        uploadRequest.contentType = contentType
        uploadRequest.acl = .publicRead
        let transferManager = AWSS3TransferManager.default()
        GGProgress.shared.showProgress()
        transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
            DispatchQueue.main.async(execute: {
                GGProgress.shared.hideProgress()
            })
            if let error = task.error {
                debugPrint("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                completion(publicURL?.absoluteString ?? keyname,imgName)
            }
            return nil
        })
    }
    //
    //
    //        let imgName = self.randomString(length: 12) + ".mp4"
    //        let keyname = path +  imgName
    //        let expression = AWSS3TransferUtilityUploadExpression()
    //        expression.setValue("public", forRequestParameter: "acl")
    //        expression.progressBlock = { (task, progress) in
    //            DispatchQueue.main.async(execute: {
    //                debugPrint(progress)
    //            })
    //        }
    //
    //        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    //        completionHandler = { (task, error) -> Void in
    //            DispatchQueue.main.async(execute: {
    //                GGProgress.shared.hideProgress()
    //                debugPrint(task.progress)
    //                debugPrint(task)
    //                debugPrint(error)
    //                // Do something e.g. Alert a user for transfer completion.
    //                // On failed uploads, `error` contains the error object.
    //            })
    //        }
    //        GGProgress.shared.showProgress()
    //        let transferUtility = AWSS3TransferUtility.default()
    //        transferUtility.uploadFile(url, bucket: AWSbucket, key: keyname, contentType: "video/mp4", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
    //            GGProgress.shared.hideProgress()
    //            if let error = task.error {
    //                print("Error : \(error.localizedDescription)")
    //            }
    //            if task.result != nil {
    //                let url = AWSS3.default().configuration.endpoint.url
    //                let publicURL = url?.appendingPathComponent(self.AWSbucket).appendingPathComponent(keyname)
    //                if let absoluteString = publicURL?.absoluteString {
    //                    // Set image with URL
    //                    print("Video URL : ",absoluteString)
    //                }
    //                completion(publicURL?.absoluteString ?? keyname,imgName)
    //            }
    //            return nil
    //        }
    //      }
}
