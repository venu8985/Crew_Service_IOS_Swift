//
//  ContractDetailViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 15/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class ContractDetailViewController: UIViewController {

    var request:Booking = Booking()

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet var imgSignature:AGImageView!
    @IBOutlet var imgAgencySignature:AGImageView!
    @IBOutlet weak var btnReject: AGButton!
    @IBOutlet weak var btnAccept: AGButton!
    @IBOutlet weak var acceptRejectView: AGView!
    var updateStatus:((Int,String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Language.get("Contract")
        lblDays.text = self.request.days.description
        lblAmount.text = self.request.total_amount.PriceString()
        lblProjectName.text = self.request.contracts.contract_name
        lblStartDate.text =  (self.request.contracts.start_at.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        lblEndDate.text = (self.request.contracts.end_at.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        lblDescription.text = self.request.contracts.contract_description
       
        self.imgSignature.sd_setImage(with: URL(string: self.request.contracts.provider_signature.LoadSignaturesImage()), placeholderImage: nil, options: [], progress: nil, completed: nil)
        self.imgAgencySignature.sd_setImage(with: URL(string: self.request.contracts.agency_signature.LoadSignaturesImage()), placeholderImage:nil, options: [], progress: nil, completed: nil)
        
        if self.request.status == "Pending"{
            self.acceptRejectView.isHidden = true
        }else if self.request.status == "Request Accepted"{
            self.acceptRejectView.isHidden = false
        }else if self.request.status == "Contract Accepted"{
            self.acceptRejectView.isHidden = true
        }else if self.request.status == "Job Done" || self.request.status == "Cancelled" || self.request.status == "Rejected"{
            self.acceptRejectView.isHidden = true
        }
        self.btnReject.action = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            CommonAPI.shared.hireresourcerejectcontract(parameters: [CWeb.hire_resource_id:self.request.id,CWeb.contract_id:self.request.contracts.id]) { data in
                self.acceptRejectView.isHidden = true
                self.updateStatus?(self.request.id,"Rejected")
            }
        }
        self.btnAccept.action = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            CommonAPI.shared.hireresourceacceptcontract(parameters: [CWeb.hire_resource_id:self.request.id,CWeb.contract_id:self.request.contracts.id]) { data in
                self.acceptRejectView.isHidden = true
                self.updateStatus?(self.request.id,"Contract Accepted")
            }
        }
        // Do any additional setup after loading the view.
    }
}
