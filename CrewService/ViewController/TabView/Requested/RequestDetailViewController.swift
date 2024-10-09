//
//  RequestDetailViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 14/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class RequestDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    var request:Booking = Booking()
    @IBOutlet weak var tableview: AGTableView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCatagoryName: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatus1: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnViewContract: AGButton!
    @IBOutlet weak var btnMileStone: AGButton!
    @IBOutlet weak var btnReject: AGButton!
    @IBOutlet weak var btnAccept: AGButton!
    @IBOutlet weak var btnNavigation: AGButton!
    @IBOutlet var imgProfile:AGImageView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var lblTitle: AGLabel!
    @IBOutlet weak var lblTime: AGLabel!
    @IBOutlet weak var lblComment: AGLabel!
    @IBOutlet weak var lblRating: AGLabel!
    
    @IBOutlet weak var acceptRejectView: AGView!
    @IBOutlet weak var projectDetailView: AGView!
    @IBOutlet weak var mainStack: UIStackView!
    var updateStatus:((Int,String)->Void)?
    var hire_resource_id = 0
    override func viewDidLoad() {
        super.viewDidLoad()

//        if UserDetails.shared.langauge == "ar"{
//            self.lblCatagoryName.textAlignment = .right
//            self.lblPrice.textAlignment = .right
//            self.lblAmount.textAlignment = .right
//            self.lblProjectName.textAlignment = .right
//        }
        
        
        self.ratingView.isHidden = true
        self.mainStack.isHidden = true
        self.setupData()
        
        self.btnViewContract.action = {
            let VC = UIStoryboard.instantiateViewController(withViewClass: ContractDetailViewController.self)
            VC.updateStatus = { id,status in
                self.request.status = status
                self.setupData()
                self.updateStatus?(id,status)
            }
            VC.request = self.request
            self.navigationController?.pushViewController(VC, animated: true)
        }
        self.btnMileStone.action = {
            let VC = UIStoryboard.instantiateViewController(withViewClass: MileStoneViewController.self)
            VC.request = self.request
            self.navigationController?.pushViewController(VC, animated: true)
        }
        self.btnReject.action = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            CommonAPI.shared.hireresourcerejectrequest(parameters: [CWeb.hire_resource_id:self.request.id]) { data in
                self.request.status = "Rejected"
                self.updateStatus?(self.request.id,"Rejected")
                self.setupData()
            }
        }
        self.btnAccept.action = {
            if UserDetails.shared.profile_status != "Verified"{
                self.OpenReviewPopupScreen()
                return
            }
            CommonAPI.shared.hireresourceacceptrequest(parameters: [CWeb.hire_resource_id:self.request.id]) { data in
                self.request.status = "Request Accepted"
                self.updateStatus?(self.request.id,"Request Accepted")
                self.setupData()
            }
        }
        self.btnNavigation.action = {
            UserDetails.shared.showGoogleDirection(latitude:self.request.latitude,longitude: self.request.longitude, address: self.request.location)
        }
        if hire_resource_id != 0{
            CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:self.request.id]) { data in
                self.request <= data
                self.setupData()
            }
        }
    }
    
    func setupData(){
        self.title = "#"+self.request.id.description
        lblDate.text = (self.request.created_at.toUTCDate(format: .serverDateFormate)?.toString(format: .requestDate) ?? "")
        lblCatagoryName.text = self.request.child_category
        lblDays.text = String(format:Language.get("for %@ Days"), self.request.days.description)
        lblPrice.text = self.request.charges.PriceString()+"/"+self.request.charges_unit.loadUnit()
        lblName.text = self.request.name
        lblLocation.text = self.request.location
        lblAmount.text = self.request.total_amount.PriceString()
        lblStatus.text = Language.get(self.request.status)
        lblStatus1.text = Language.get(self.request.project_status)
        lblStatus1.textColor = self.request.project_status.ProjectStatusColor()
        lblProjectName.text = self.request.project_name
        lblStartDate.text = (self.request.start_at.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        lblEndDate.text = (self.request.end_at.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        lblDescription.text = self.request.descriptions
        
        self.imgProfile.sd_setImage(with: URL(string: self.request.profile_image.LoadProvidersImage()), placeholderImage: UIImage(named: "user"), options: [], progress: nil, completed: nil)
    
        self.tableview.reloadData()

        if self.request.status == "Pending"{
            self.acceptRejectView.isHidden = false
        }else if self.request.status == "Request Accepted"{
            self.acceptRejectView.isHidden = true
        }else if self.request.status == "Contract Accepted"{
            self.acceptRejectView.isHidden = true
            self.projectDetailView.isHidden = true
        }else if self.request.status == "Job Done" || self.request.status == "Cancelled" || self.request.status == "Rejected" || self.request.project_status == "Completed"{
            self.projectDetailView.isHidden = true
            self.acceptRejectView.isHidden = true
        }
        self.mainStack.isHidden = false
        
        if self.request.provider_review_id != 0{
            self.ratingView.isHidden = false
            self.lblTitle.text = self.request.name
            self.lblTime.text = self.request.name
            self.lblComment.text = self.request.feedback
            self.lblRating.text = self.request.rating.description
        }else{
            self.ratingView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.request.slots.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotTableViewCell", for: indexPath) as! SlotTableViewCell
        cell.setupData(model: self.request.slots[indexPath.row])
        self.tableview.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
class SlotTableViewCell:UITableViewCell{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    var object:SlotsModel?
    func setupData(model:SlotsModel?){
        self.object = model
        self.lblDate.text = (self.object?.start_at.toLocalDate(format: .sendDate)?.toString(format: .dateMMM) ??  "") + " - " + (self.object?.end_at.toLocalDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        if self.object?.days == 1{
            self.lblDays.text = (self.object?.days.description ?? "")+" "+Language.get("Day")
        }else{
            self.lblDays.text = (self.object?.days.description ?? "")+" "+Language.get("Days")
        }
        
    }
}
