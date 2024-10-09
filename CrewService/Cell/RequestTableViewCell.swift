//
//  RequestTableViewCell.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 03/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    @IBOutlet var lblRequestId:AGLabel!
    @IBOutlet var lblRequestDate:AGLabel!
    @IBOutlet var lblUserName:AGLabel!
    @IBOutlet var lblUserAddress:AGLabel!
    @IBOutlet var imgUser:AGImageView!
    
    @IBOutlet var lblSkill:AGLabel!
    @IBOutlet var lblPrice:AGLabel!
    @IBOutlet var lblRequestedDays:AGLabel!
    @IBOutlet var lblRequestedDate:AGLabel!
    @IBOutlet var lblTotalAmount:AGLabel!

    @IBOutlet var btnContract:AGButton!
    @IBOutlet var btnInfo:AGButton!

    var object:Booking = Booking()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDetails.shared.langauge == "ar"{
            self.lblRequestId.textAlignment = .right
            self.lblRequestDate.textAlignment = .left
            self.lblUserName.textAlignment = .right
            self.lblSkill.textAlignment = .right
            self.lblPrice.textAlignment = .right
            self.lblUserAddress.textAlignment = .right
        }
        btnInfo.action = {
            
        }
        btnContract.action = {
//            let vc = UIStoryboard.instantiateViewController(withViewClass: QuoteNowViewController.self)
//            vc.object = self.object
//            vc.completionHandler = {
//                self.cancelRequest?()
//            }
//            vc.modalPresentationStyle = .overFullScreen
//            AppDelegate.shared.present(VC: vc, animated: true)
        }
    }
    func setupData(model:Booking){
        self.object = model
        self.lblUserAddress.text = self.object.location
        self.lblUserName.text = self.object.name
        self.lblRequestId.text = "#"+self.object.id.description
        self.lblRequestDate.text = (self.object.created_at.toUTCDate(format: .serverDateFormate)?.toString(format: .requestDate) ?? "")
        self.lblRequestedDays.text = Language.get("Request for")+" - "+self.object.days.description + " " + Language.get("Days")
        self.lblRequestedDate.text = (self.object.start_at.toUTCDate(format: .sendDate)?.toString(format: .dateDDMM) ?? "") + "-" + (self.object.end_at.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        self.lblSkill.text = self.object.child_category
        self.lblPrice.text = self.object.charges.PriceString()+"/"+self.object.charges_unit.loadUnit()
        self.lblTotalAmount.text = self.object.total_amount.PriceString()
        self.imgUser.setImage(url: self.object.profile_image.LoadUserImage(), placeholderImage: UIImage(named: "user")!)
    }
}
