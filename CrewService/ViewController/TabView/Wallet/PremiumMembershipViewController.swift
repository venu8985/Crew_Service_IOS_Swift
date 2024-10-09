//
//  PremiumMembershipViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 22/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class PremiumMembershipViewController: UIViewController {

    @IBOutlet weak var btnUpgrede: AGButton!
    @IBOutlet weak var btnNoThanks: AGButton!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFree: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAmount.text = UserDetails.shared.registration_fees+" SAR"
        self.lblDay.text = ""
        if let t = UserDetails.shared.expired_at.toLocalDate(format: .sendDate)?.toAgeDays(){
            self.lblDay.text =  t>0 ? t.description : "0"
            self.btnNoThanks.isHidden = t <= 0
            if UserDetails.shared.payment_status == "Paid",t<=0{
                lblFree.text = NSLocalizedString("of Subscription", comment: "")
            }
        }
        self.lblDate.text = UserDetails.shared.expired_at.toLocalDate(format: .sendDate)?.toString(format: .dateMMM)
        //self.btnNoThanks.applyUnderline()
        self.btnUpgrede.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: PayNowViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.btnNoThanks.action = {
            var param:GGParameters = [:]
            GGWebServices(getRequest: .activatetrial, parameters: param)
                .responseJSON { (result) in
                    switch result {
                    case .success(let json, _):
                        if result.isSuccess{
                            AppDelegate.shared.SetTabBarMainView()
                        }
                        break
                    case .failer(let error):
                        self.displayAPIFalseError(string: error.alertMessage)
                        break
                    }
            }
        }
    }
}
