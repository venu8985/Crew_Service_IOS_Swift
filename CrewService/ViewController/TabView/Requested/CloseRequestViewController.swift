//
//  CloseRequestViewController.swift
//  TasmemcomUser
//
//  Created by Gaurav Gudaliya R on 30/06/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class CloseRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var List:[Booking] = []
    var pagination: PullToRefreshModel = PullToRefreshModel(page: 1)
    @IBOutlet var NoDataView:UIView!
    @IBOutlet var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerNib(RequestTableViewCell.self)
        self.NoDataView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func ListAPICall(Currentpage:Int){
        CommonAPI.shared.hireresourcerequests(parameters: [CWeb.page:Currentpage,CWeb.type:"completed"],isShow:self.List.count == 0) { mainData in
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
                    var temp:[Booking] = []
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
        let cell = tableView.dequeueReusableCell(withClassIdentifier: RequestTableViewCell.self, for: indexPath)
        cell.setupData(model: self.List[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = UIStoryboard.instantiateViewController(withViewClass: RequestDetailViewController.self)
        VC.request = self.List[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
extension CloseRequestViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
        pagination = PullToRefreshModel(page: 1)
        self.ListAPICall(Currentpage: 1)
    }
}
