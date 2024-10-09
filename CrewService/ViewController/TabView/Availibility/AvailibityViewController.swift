
import UIKit

class AvailibityViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var List:[ProviderModel] = []
    var pagination: PullToRefreshModel = PullToRefreshModel(page: 1)
    @IBOutlet var NoDataView:UIView!
    @IBOutlet var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NoDataView.isHidden = true
        self.title = Language.get("My Availability")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList), name: NSNotification.Name("NewRequest"), object: nil)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.List = []
        for t in UserDetails.shared.profiles {
            for tt in t.profiles{
                self.List.append(tt)
            }
        }
      //  self.reloadList()
    }
    @objc func reloadList(){
        pagination = PullToRefreshModel(page: 1)
        self.ListAPICall(Currentpage: 1)
    }
    @objc func reloadTable(){
        self.table.reloadData()
    }
    func ListAPICall(Currentpage:Int){
        CommonAPI.shared.hireresourcerequests(parameters: [CWeb.page:Currentpage,CWeb.type:"new"],isShow:self.List.count == 0) { mainData in
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
                    var temp:[ProviderModel] = []
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
//        pagination.isLoadMoreDataWebservices(index: indexPath, data: self.List, completionsHandler: {
//            self.ListAPICall(Currentpage: self.pagination.getPageIndex())
//        })
        let cell = tableView.dequeueReusableCell(withClassIdentifier: AvailibityTableViewCell.self, for: indexPath)
        cell.setupData(model: self.List[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDetails.shared.profile_status != "Verified"{
            self.OpenReviewPopupScreen()
            return
        }
        let vc = UIStoryboard.instantiateViewController(withViewClass: AvailibilityListViewController.self)
        vc.provider = self.List[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
class AvailibityTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName:AGLabel!
    @IBOutlet var lblPrice:AGLabel!
    @IBOutlet var imgUser:AGImageView!
    
    var object:ProviderModel = ProviderModel()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDetails.shared.langauge == "ar"{
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right
        }
    }
    func setupData(model:ProviderModel){
        self.object = model
        self.lblName.text = self.object.category_name
        self.lblPrice.text = self.object.charges.PriceString()+"/"+self.object.charges_unit.loadUnit()
        if self.object.gallery.count > 0{
            if self.object.gallery[0].thumb == ""{
                self.imgUser.setImage(url: self.object.gallery[0].filename.LoadGalleryImage(), placeholderImage: UIImage(named: "placeholder")!)
            }else{
                self.imgUser.setImage(url: self.object.gallery[0].thumb.LoadGalleryImage(), placeholderImage: UIImage(named: "placeholder")!)
            }
        }else{
            self.imgUser.image = UIImage(named: "placeholder")
        }
    }
}
