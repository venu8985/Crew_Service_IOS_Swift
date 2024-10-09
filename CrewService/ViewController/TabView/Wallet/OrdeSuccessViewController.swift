//
//  otpVarification.swift
//  logistiom3
//
//  Created by HTF India on 9/17/19.
//  Copyright © 2019 TeFe. All rights reserved.
//

import UIKit

class OrdeSuccessViewController: UIViewController {
    
    @IBOutlet weak var btnBack: AGButton!
    var dismissHandler:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 25, height: 25))
//        imageView.flipImage()
        if let imgBackArrow = UIImage(named: "back") {
            imageView.image = imgBackArrow
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain1))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        // self.lblDeliveryTime.text = UserDetails.shared.LocalDB.food_delivery_time.value
        btnBack.action = {
            self.dismissHandler?()
            self.dismiss(animated: false)
        }
    }
    @objc func backToMain1() {
        self.dismissHandler?()
        self.dismiss(animated: false)
    }
}
