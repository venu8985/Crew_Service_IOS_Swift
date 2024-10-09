//
//  AvailibilityListViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 11/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//
import UIKit

class AvailibilityListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout   {

    @IBOutlet weak var ScPageControl: SCPageControlView!
    @IBOutlet var collection:UICollectionView!
    @IBOutlet weak var tableview: AGTableView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    private var currentCalendar: Calendar?
    var firstdate = ""
    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet weak var btnNext: AGButton!
    @IBOutlet weak var btnPre: AGButton!
    
    @IBOutlet weak var btnConfirm: AGButton!

    var provider:ProviderModel = ProviderModel()
    var object:AvailibilityDetailModel = AvailibilityDetailModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.isHidden = true
        self.collection.isHidden = true
        self.ScPageControl.isHidden = true
        
        ScPageControl.backgroundColor = UIColor.clear
        ScPageControl.scp_style = .SCJAFlatBar
        self.title = self.provider.category_name
        if UserDetails.shared.langauge == "ar"{
            btnNext.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnPre.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
       
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale.current
        currentCalendar?.timeZone = TimeZone.current
        self.tableview.tableFooterView = UIView()
        
        self.btnPre.action = {
            self.calendarView.loadPreviousView()
        }
        self.btnNext.action = {
            self.calendarView.loadNextView()
        }
       
        self.btnConfirm.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: MakeBusyViewController.self)
            vc.provider = self.provider
            vc.completionHandler = {
                self.getDataFromServer()
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true) {
                
            }
        }
       
        self.firstdate =  Date().toString(format: "yyyy-MM-dd")
        self.monthLabel.text = self.firstdate.toUTCDate(format: .sendDate)?.toString(format: "MMM YYYY")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.calendarView.contentController.refreshPresentedMonth()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        if self.calendarView.calendarMode != .monthView{
            self.calendarView.changeMode(.monthView)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataFromServer()
    }
    func getDataFromServer(){
        CommonAPI.shared.getcalenderdata(parameters: [CWeb.provider_profile_id:self.provider.id]) { data in
            self.object <= data
            self.tableview.isHidden = self.object.shootingPlans.count == 0
            self.collection.isHidden =  self.object.profileSlots.count == 0
            self.ScPageControl.isHidden =  self.object.profileSlots.count == 0
            self.tableview.reloadData()
            self.collection.reloadData()
            self.ScPageControl.set_view(self.object.profileSlots.count, current: 0, current_color: UIColor.appRed)
            self.calendarView.contentController.refreshPresentedMonth()
        }
    }
    func getDayOfWeek(_ today:String) -> Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return 1 }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collection{
            ScPageControl.scroll_did(scrollView)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object.shootingPlans.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: ShootingTableViewCell.self, for: indexPath)
        cell.setupData(model: self.object.shootingPlans[indexPath.row])
        cell.updateObjectHandler = { obj in
            self.object.shootingPlans[indexPath.row] = obj
        }
        self.tableview.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.object.profileSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VacationCollectionCell", for: indexPath) as! VacationCollectionCell
        cell.deleteHandler = {
            CommonAPI.shared.deletebusyslot(parameters: [CWeb.profile_slot_id:self.object.profileSlots[indexPath.row].id]) { data in
                self.object.profileSlots.remove(at: indexPath.row)
                self.collection.reloadData()
                self.getDataFromServer()
            }
        }
        cell.setupData(model: self.object.profileSlots[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
}
class VacationCollectionCell:UICollectionViewCell{
    @IBOutlet var lblStartDate:AGLabel!
    @IBOutlet var lblEndDate:AGLabel!
    @IBOutlet var viewBG:AGView!
    @IBOutlet var btnCancel:AGButton!
    var object:ProfileSlotsModel = ProfileSlotsModel()

    var deleteHandler:(()->Void)?
    override func awakeFromNib() {
        self.btnCancel.action = {
            self.deleteHandler?()
        }
    }
    func setupData(model:ProfileSlotsModel){
        self.object = model
        self.lblStartDate.text = self.object.start_date.toUTCDate(format: .sendDate)?.toString(format: .dateEEE)
        self.lblEndDate.text = self.object.end_date.toUTCDate(format: .sendDate)?.toString(format: .dateEEE)
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension AvailibilityListViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? { return currentCalendar }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return UIColor.appRed
    }
    
    func shouldShowWeekdaysOut() -> Bool { return true }

    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
        if let d = dayView.date{
            let date = dayView.date.dateFormattedStringWithFormat("yyyy-MM-dd", fromDate: d.convertedDate()!)
            if self.object.busySlots.contains(date){
                return true
            }
        }
        return false
    }
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{
        return [UIColor.red]
    }
//    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat{
//        return 0
//    }
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat{return 5}
    

    // Defaults to true
    func shouldAnimateResizing() -> Bool { return true }
    
    func shouldSelectDayView(dayView: DayView) -> Bool {
        return false
    }
    func shouldScrollOnOutDayViewSelection() -> Bool { return false }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool { return false }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool { return false }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        if let d = dayView.date{
            let date = dayView.date.dateFormattedStringWithFormat("yyyy-MM-dd", fromDate: d.convertedDate()!)
            if self.firstdate != date{
                self.firstdate = date
                self.calendarView.contentController.refreshPresentedMonth()
            }
        }
    }
    
    func shouldSelectRange() -> Bool { return false }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription{
            self.monthLabel.text = date.globalDescription
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return false }
    
    func weekdaySymbolType() -> WeekdaySymbolType { return .short }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool { return false }
    
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.rect)
        circleView.fillColor = UIColor.appBlack
        circleView.strokeColor = UIColor.clear
        return circleView
//        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
//        circleView.fillColor = .clear
//        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let d = dayView.date{
            let date = dayView.date.dateFormattedStringWithFormat("yyyy-MM-dd", fromDate: d.convertedDate()!)
            if self.firstdate == date{
                dayView.dayLabel?.textColor = .white
            }
            if self.firstdate == date{
                return true
            }
        }
        return false
    }
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.rect)
        circleView.fillColor = .clear
        return circleView
//        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.rect)
//        circleView.fillColor = UIColor.appBlack
//        circleView.strokeColor = UIColor.clear
//        return circleView
    }
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let d = dayView.date{
            let date = dayView.date.dateFormattedStringWithFormat("yyyy-MM-dd", fromDate: d.convertedDate()!)
            if self.firstdate == date{
                dayView.dayLabel?.textColor = .white
            }
            if self.firstdate == date{
                return true
            }
        }
        return false
    }
    
    func dayOfWeekTextColor() -> UIColor { return .black }
    
    func dayOfWeekBackGroundColor() -> UIColor { return .clear }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 1000
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        }
        
        return Date()
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension AvailibilityListViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.init(name: "AvenirLTStd-Roman", size: 15.0) ?? UIFont.systemFont(ofSize: 15)
    }
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .out, _): return UIColor.lightGray
        case (_, .out, _): return UIColor.lightGray
        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectedText
        case (.sunday, .in, _): return UIColor.black
        case (.sunday, _, _): return UIColor.black
        case (_, .in, _): return UIColor.black
        default: return UIColor.lightGray
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return UIColor.clear
        case (_, .selected, _), (_, .highlighted, _): return UIColor.clear
        default: return nil
        }
    }
}
// MARK: - Convenience API Demo
extension AvailibilityListViewController {

    func didShowNextMonthView(_ date: Date) {
        self.calendarView.contentController.refreshPresentedMonth()
    }
    func didShowPreviousMonthView(_ date: Date) {
        self.calendarView.contentController.refreshPresentedMonth()
    }
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {

        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {

        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
}

