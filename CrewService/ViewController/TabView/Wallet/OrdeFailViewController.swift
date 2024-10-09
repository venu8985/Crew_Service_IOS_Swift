//
//  otpVarification.swift
//  logistiom3
//
//  Created by HTF India on 9/17/19.
//  Copyright © 2019 TeFe. All rights reserved.
//

import UIKit

class OrdeFailViewController: UIViewController {
    
    @IBOutlet weak var btnTryAgin: AGButton!
    @IBOutlet var lblMessage: UILabel!
    var message = ""
    var completionHandler:((Bool)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblMessage.text = message
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true

        btnTryAgin.action = {
            self.dismiss(animated: true)
            self.completionHandler?(false)
        }
    }
}
