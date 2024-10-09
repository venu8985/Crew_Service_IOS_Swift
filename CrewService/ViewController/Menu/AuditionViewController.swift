//
//  ShootingViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 03/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class AuditionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var List:[AuditionModel] = []
    var pagination: PullToRefreshModel = PullToRefreshModel(page: 1)
    @IBOutlet var NoDataView:UIView!
    @IBOutlet var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Audition Requests")
        self.reloadList()
        self.NoDataView.isHidden = true
        self.navigationController?.setupWhiteTintColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList), name: NSNotification.Name("NewRequest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTable), name: UIApplication.didBecomeActiveNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @objc func reloadList(){
        pagination = PullToRefreshModel(page: 1)
        self.ListAPICall(Currentpage: 1)
    }
    @objc func reloadTable(){
        self.table.reloadData()
    }
    func ListAPICall(Currentpage:Int){
        CommonAPI.shared.auditions(parameters: [CWeb.page:Currentpage],isShow:self.List.count == 0) { mainData in
            if let last_page = mainData["last_page"] as? Int {
                if Currentpage == 1{
                    self.List = []
                    self.table.pullToRefresh = { ag in
                        ag.endRefreshing()
                        self.pagination = PullToRefreshModel(page: 1)
                        self.ListAPICall(Currentpage: 1)
                    }
                }
                if (Currentpage == last_page){
                    self.pagination.stop()
                }
                if let data = mainData["data"] as? [[String: AnyObject]] {
                    var temp:[AuditionModel] = []
                    temp <= data
                    for t in temp {
                        self.List.append(t)
                    }
                    self.pagination.responseData(withNewData: temp,lastPage:last_page)
                }
            }
            self.table.reloadData()
            if self.List.count == 0 {
                self.NoDataView.isHidden = false
            }else{
                self.NoDataView.isHidden = true
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.List.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        pagination.isLoadMoreDataWebservices(index: indexPath, data: self.List, completionsHandler: {
            self.ListAPICall(Currentpage: self.pagination.getPageIndex())
        })
        let cell = tableView.dequeueReusableCell(withClassIdentifier: AuditionTableViewCell.self, for: indexPath)
        cell.setupData(model: self.List[indexPath.row])
        cell.updateObjectHandler = { obj in
            self.List[indexPath.row] = obj
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
class AuditionTableViewCell: UITableViewCell {
    
    @IBOutlet var lblProjectTitle:AGLabel!
    @IBOutlet var lblAddressTitle:AGLabel!
    @IBOutlet var lblShootingDate:AGLabel!
    @IBOutlet var lblProjectName:AGLabel!
    @IBOutlet var lblAddress:AGLabel!
    @IBOutlet var btnLocation:AGButton!
    @IBOutlet var btnAcceptRequest:AGButton!
    @IBOutlet var btnRejectRequest:AGButton!
    @IBOutlet var lblStatus:AGLabel!
    
    var object:AuditionModel = AuditionModel()
    var updateObjectHandler:((AuditionModel)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDetails.shared.langauge == "ar"{
            self.lblProjectTitle.textAlignment = .left
            self.lblAddressTitle.textAlignment = .left
            self.lblShootingDate.textAlignment = .left
            self.lblProjectName.textAlignment = .right
            self.lblAddress.textAlignment = .right
        }
        btnLocation.action = {
            UserDetails.shared.showGoogleDirection(latitude:self.object.latitude,longitude: self.object.longitude, address: self.object.location)
        }
        btnAcceptRequest.action = {
            var parameters:GGParameters = [:]
            parameters[CWeb.audition_id] = self.object.id
            CommonAPI.shared.acceptaudition(parameters: parameters) { data in
                self.object.status = "Accepted"
                self.setupData(model: self.object)
                self.updateObjectHandler?(self.object)
            }
        }
        btnRejectRequest.action = {
            var parameters:GGParameters = [:]
            parameters[CWeb.audition_id] = self.object.id
            CommonAPI.shared.rejectaudition(parameters: parameters) { data in
                self.object.status = "Rejected"
                self.setupData(model: self.object)
                self.updateObjectHandler?(self.object)
            }
        }
    }
    func setupData(model:AuditionModel){
        self.object = model
        self.lblShootingDate.text = (self.object.audition_date.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        self.lblProjectName.text = self.object.project_name
        self.lblAddress.text = self.object.location
        self.lblStatus.text = Language.get(self.object.status)
        if self.object.status == "Pending"{
            self.lblStatus.isHidden = true
            self.btnAcceptRequest.isHidden = false
            self.btnRejectRequest.isHidden = false
        }else{
            self.lblStatus.isHidden = false
            self.btnAcceptRequest.isHidden = true
            self.btnRejectRequest.isHidden = true
        }
    }
}
