//
//  PayNowViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 22/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class PayNowViewController: UIViewController {

    @IBOutlet weak var btnPaynow: AGButton!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var lblAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAmount.text = UserDetails.shared.registration_fees+" SAR"
        self.btnPaynow.action = {
            let vc = PaymentViewController()
            vc.completionHandler = { status,message in
                if status{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: OrdeSuccessViewController.self)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.dismissHandler = {
                        AppDelegate.shared.SetTabBarMainView()
                    }
                    self.present(vc, animated: true)
                }else{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: OrdeFailViewController.self)
                    vc.message = message
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            }
            self.present(UINavigationController(rootViewController: vc), animated: true)
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
}
