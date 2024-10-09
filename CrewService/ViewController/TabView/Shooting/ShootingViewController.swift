//
//  ShootingViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 03/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class ShootingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var List:[ShootingPlanModel] = []
    var pagination: PullToRefreshModel = PullToRefreshModel(page: 1)
    @IBOutlet var NoDataView:UIView!
    @IBOutlet var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Shooting Plan")
        self.reloadList()
        self.NoDataView.isHidden = true
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
        CommonAPI.shared.shootingplans(parameters: [CWeb.page:Currentpage],isShow:self.List.count == 0) { mainData in
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
                    var temp:[ShootingPlanModel] = []
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
        let cell = tableView.dequeueReusableCell(withClassIdentifier: ShootingTableViewCell.self, for: indexPath)
        cell.setupData(model: self.List[indexPath.row])
        cell.updateObjectHandler = { obj in
            self.List[indexPath.row] = obj
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let VC = UIStoryboard.instantiateViewController(withViewClass: NewRequestDetailViewController.self)
        //        VC.request = self.List[indexPath.row]
        //        VC.quoteSubmited = {
        //            self.List.remove(at: indexPath.row)
        //            self.table.deleteRows(at: [indexPath], with: .fade)
        //            self.NoDataView.isHidden = self.List.count != 0
        //            self.table.reloadData()
        //        }
        //        self.navigationController?.pushViewController(VC, animated: true)
    }
}
class ShootingTableViewCell: UITableViewCell {
    
    @IBOutlet var lblShootingDate:AGLabel!
    @IBOutlet var lblProjectName:AGLabel!
    @IBOutlet var lblAddress:AGLabel!
    @IBOutlet var btnRequest:AGButton!
    @IBOutlet var btnLocation:AGButton!
    
    var object:ShootingPlanModel = ShootingPlanModel()
    var updateObjectHandler:((ShootingPlanModel)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDetails.shared.langauge == "ar"{
            self.lblShootingDate.textAlignment = .left
            self.lblProjectName.textAlignment = .right
            self.lblAddress.textAlignment = .right
        }
        btnLocation.action = {
            UserDetails.shared.showGoogleDirection(latitude:self.object.latitude,longitude: self.object.longitude, address: self.object.location)
        }
        btnRequest.action = {
            if UserDetails.shared.profile_status != "Verified"{
                self.parentViewController?.OpenReviewPopupScreen()
                return
            }
            let vc = UIStoryboard.instantiateViewController(withViewClass: RequestChangeViewController.self)
            vc.object = self.object
            vc.completionHandler = { date in
                self.object.reschedule_date = date
                self.updateObjectHandler?(self.object)
                self.setupData(model: self.object)
            }
            vc.modalPresentationStyle = .overFullScreen
            AppDelegate.shared.topViewController()?.navigationController?.present(vc, animated: true) {
                
            }
        }
    }
    func setupData(model:ShootingPlanModel){
        self.object = model
        self.lblShootingDate.text = (self.object.shooting_date.toUTCDate(format: .sendDate)?.toString(format: .dateMMM) ?? "")
        self.lblProjectName.text = self.object.project_name
        self.lblAddress.text = self.object.location
    }
}
