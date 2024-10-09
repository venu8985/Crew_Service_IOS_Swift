//
//  MileStoneViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class MileStoneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var request:Booking = Booking()
    @IBOutlet weak var btnRemainder: AGButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblPendingAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Milestones")
        self.lblTotalAmount.text = self.request.total_amount.PriceString()
        self.lblPendingAmount.text = self.request.remaining_amount.PriceString()
        self.btnRemainder.action = {
            CommonAPI.shared.milestonepaymentreminder(parameters: [CWeb.hire_resource_id:self.request.id]) { data in
                
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setupWhiteTintColor()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.request.milestones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MileStoneTableViewCell", for: indexPath) as! MileStoneTableViewCell
        cell.setupData(model: self.request.milestones[indexPath.row])
        cell.updateObject = { t in
            self.request.milestones[indexPath.row] = t
        }
        self.tableview.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
class MileStoneTableViewCell:UITableViewCell{
    @IBOutlet weak var lblDate: AGButton!
    @IBOutlet weak var lblStatus: AGButton!
    @IBOutlet weak var lblTitle: AGLabel!
    @IBOutlet weak var lblPrice: AGLabel!
    @IBOutlet weak var lblDescription: AGLabel!
    @IBOutlet weak var lblPaymentReceDate: AGLabel!
    @IBOutlet weak var btnRecevied: AGButton!
    @IBOutlet weak var btnNotRecevied: AGButton!
    @IBOutlet weak var lblPaymentStatus: AGLabel!
    @IBOutlet weak var buttonView: AGView!
    
    @IBOutlet weak var viewLine: AGView!
    @IBOutlet weak var viewCircle: AGView!
    var updateObject:((MilestonesModel)->Void)?
    override func awakeFromNib() {
        self.btnRecevied.action = {
            CommonAPI.shared.milestonepaymentreceived(parameters: [CWeb.contract_milestone_id:self.object!.id]) { data in
                self.object!.status = "Paid"
                self.updateObject?(self.object!)
                self.setupData(model:self.object!)
            }
        }
        self.btnNotRecevied.action = {
            CommonAPI.shared.milestonepaymentnotreceived(parameters: [CWeb.contract_milestone_id:self.object!.id]) { data in
                self.object!.status = "Pending"
                self.updateObject?(self.object!)
                self.setupData(model:self.object!)
            }
        }
    }
    
    var object:MilestonesModel?
    func setupData(model:MilestonesModel?){
        self.object = model
        self.lblDate.setTitle((self.object?.milestone_date.toLocalDate(format: .sendDate)?.toString(format: .dateMMM) ?? ""), for: .normal)
        self.lblStatus.setTitle(self.object?.status, for: .normal)
        self.lblPaymentReceDate.text = (self.object?.paid_at.toLocalDate(format: .milestone)?.toString(format: .serverDisplayDateFormate) ?? "")

        self.lblDescription.text = self.object?.descriptions
        self.lblPrice.text = self.object?.milestone_amount.PriceString()
        self.lblTitle.text = self.object?.title
        self.btnRecevied.isHidden = true
        self.btnNotRecevied.isHidden = true
        self.lblPaymentStatus.isHidden = true
        self.lblPaymentReceDate.isHidden = true
        self.buttonView.isHidden = true
        self.viewLine.borderColor = .appGray
        self.viewCircle.borderColor = .appGray
        if self.object?.status == "Paid"{
            self.lblDate.isHidden = true
            self.btnRecevied.isHidden = true
            self.btnNotRecevied.isHidden = true
            self.lblPaymentStatus.isHidden = false
            self.lblPaymentReceDate.isHidden = false
            self.buttonView.isHidden = false
            self.viewLine.borderColor = .appGreen
            self.viewCircle.borderColor = .appGreen
        }else if self.object?.status == "Pending"{
            
        }else if self.object?.status == "Waiting for confirmation"{
            self.btnRecevied.isHidden = false
            self.btnNotRecevied.isHidden = false
            self.lblPaymentStatus.isHidden = true
            self.lblPaymentReceDate.isHidden = true
            self.buttonView.isHidden = false
        }
    }
}
