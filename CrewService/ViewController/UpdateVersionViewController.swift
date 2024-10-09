//
//  UpdateVersionViewController.swift
//  DivaFitness
//
//  Created by Gaurav Gudaliya on 29/04/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class UpdateVersionViewController: UIViewController {

    @IBOutlet weak var lblTitle: AGLabel!
    @IBOutlet weak var lblNewComment: AGLabel!
    @IBOutlet weak var lblWhatisNew: AGLabel!
    
    @IBOutlet weak var btnUpdate: AGButton!
    var modelVersion:Model?
    var version = ""
    var comment  = "Bug fix and improved app perfomance"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = Language.get("Launched New Version")+" "+version
        self.lblWhatisNew.text = Language.get("What is the new in")+" "+version
        self.lblNewComment.text = comment
        
        if let model = self.modelVersion{
            self.lblTitle.text = Language.get("Launched New Version")+" "+model.version
            self.lblWhatisNew.text = Language.get("What is the new in")+" "+model.version
            self.lblNewComment.text = model.releaseNotes
        }
        CheckAppUpdateModel.shared.checkAppUpdate { (model) in
            self.modelVersion = model
            self.lblTitle.text = Language.get("Launched New Version")+" "+model.version
            self.lblWhatisNew.text = Language.get("What is the new in")+" "+model.version
            self.lblNewComment.text = model.releaseNotes
            if model.updateType == .unknown{
                //model.launchAppStore()
            }else{
                //update to server
            }
        } completetionErrorHandler: { (error) in
            debugPrint(error)
        }
        self.btnUpdate.action = {
            if let model = self.modelVersion{
                model.launchAppStore()
            }else{
                if let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id1601820293?mt=8"), UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}
