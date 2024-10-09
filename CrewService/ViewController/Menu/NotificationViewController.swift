//
//  TabBarViewController.swift
//  Batakah
//
//  Created by Gaurav Gudaliya R on 05/04/19.
//  Copyright © 2019 Divyesh Savaliya. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var List:[NotificationModel] = []
    var pagination: PullToRefreshModel = PullToRefreshModel(page: 1)
    @IBOutlet var tableView:UITableView!
    @IBOutlet var NoDataView:UIView!
    @IBOutlet var lblNodata:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Notifications")
        self.navigationController?.setupWhiteTintColor()
        self.NoDataView.isHidden = true
        self.pagination = PullToRefreshModel(page: 1)
        self.ListAPICall(Currentpage: 1)
        self.tableView.tableFooterView = UIView()
        self.lblNodata.text = Language.get("No Notification Found.")
        self.tableView.pullToRefresh = { ag in
            ag.endRefreshing()
            self.pagination = PullToRefreshModel(page: 1)
            self.ListAPICall(Currentpage: 1)
        }
    }
    @objc func btnClearAll(){
        AGAlertBuilder(withAlert: nil, message: Language.get("Are you want to delete all Notifications?"))
            .addAction(with: Language.get("No"), style: .cancel, handler: { _ in
                
            })
            .addAction(with: Language.get("Yes"), style: .default, handler: { _ in
                CommonAPI.shared.deletenotification(parameters: [:]) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .show()
    }
    func ListAPICall(Currentpage:Int){
        CommonAPI.shared.notifications(parameters: [CWeb.page:Currentpage,CWeb.order_by:Currentpage==1 ? "oldest" : "oldest",CWeb.created_at: Currentpage == 1 ? "" : self.List.last!.created_at]) { mainData in
            if Currentpage == 1{
                self.List = []
            }
            if (mainData.count == 0){
                self.pagination.stop()
            }
            var temp:[NotificationModel] = []
            temp <= mainData
            for t in temp {
                self.List.append(t)
            }
            self.pagination.responseData(withNewData: temp)
            self.tableView.reloadData()
            if self.List.count == 0 {
                self.NoDataView.isHidden = false
            }else{
                self.navigationItem.setRightBarButton(UIBarButtonItem(title: Language.get("Clear All"), style: .done, target: self, action: #selector(self.btnClearAll)), animated: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.setUpData(model: self.List[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            CommonAPI.shared.deletenotification(parameters: [CWeb.notification_id:self.List[indexPath.row].id]) {_ in
                self.List.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.NoDataView.isHidden = self.List.count != 0
            }
            completionHandler(true)
        }
        if #available(iOS 13.0, *) {
            delete.image = UIImage(systemName: "trash")
        } else {
            delete.title = Language.get("DELETE")
        }
        delete.backgroundColor = UIColor.red
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notify_type = self.List[indexPath.row].notify_type
        if notify_type == "auditionRequestReceived"{
            let vc = UIStoryboard.instantiateViewController(withViewClass: AuditionViewController.self)
            AppDelegate.shared.pushViewController(VC: vc, animated: true)
        }
        else if notify_type == "contractReceived"{
            var request:Booking = Booking()
            CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:self.List[indexPath.row].value]) { data in
                request <= data
                let vc = UIStoryboard.instantiateViewController(withViewClass: RequestDetailViewController.self)
                vc.request = request
                AppDelegate.shared.pushViewController(VC: vc, animated: true)
            }
        }
        else if notify_type == "hireAgency"{
            var request:Booking = Booking()
            CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:self.List[indexPath.row].value]) { data in
                request <= data
                let vc = UIStoryboard.instantiateViewController(withViewClass: RequestDetailViewController.self)
                vc.request = request
                AppDelegate.shared.pushViewController(VC: vc, animated: true)
            }
        }
        else if notify_type == "milestonePaymentReleased"{
            var request:Booking = Booking()
            CommonAPI.shared.hireresourcerequestdetails(parameters: [CWeb.hire_resource_id:self.List[indexPath.row].value]) { data in
                request <= data
                let vc = UIStoryboard.instantiateViewController(withViewClass: MileStoneViewController.self)
                vc.request = request
                AppDelegate.shared.pushViewController(VC: vc, animated: true)
            }
        }
        else if notify_type == "shootingPlanCreated"{
            let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabViewController.self)
             VC.selectedIndex = 2
             AppDelegate.shared.window?.rootViewController = VC
        }
    }
}


class NotificationCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var object:NotificationModel = NotificationModel()
    func setUpData(model:NotificationModel){
        self.object = model
        if UserDetails.shared.langauge == "en"{
            lblName.textAlignment = .left
        }else{
            lblName.textAlignment = .right
        }
        lblName.text = self.object.title
        lblMessage.text = self.object.descriptions
        lblMessage.isHidden = self.object.descriptions == ""
        lblTime.text = self.object.created_at.toUTCDate(format: .serverDateFormate)?.timePassed() ?? self.object.created_at
    }
}

