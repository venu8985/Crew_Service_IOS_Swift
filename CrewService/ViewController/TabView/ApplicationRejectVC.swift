//
//  otpVarification.swift
//  logistiom3
//
//  Created by HTF India on 9/17/19.
//  Copyright © 2019 TeFe. All rights reserved.
//9662015630

import UIKit

class ApplicationRejectVC: UIViewController {

    @IBOutlet weak var btnResumbit: AGButton!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        btnResumbit.action = {
           
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
