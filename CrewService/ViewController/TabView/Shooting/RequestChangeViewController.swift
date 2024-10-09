//
//  MakeBusyViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 11/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class RequestChangeViewController: UIViewController {

    var object:ShootingPlanModel = ShootingPlanModel()
    @IBOutlet weak var btnStartDate: AGButton!
    @IBOutlet var txtStartDate:UnderLineTextField!
    @IBOutlet weak var btnConfirm: AGButton!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnClose1: AGButton!
    var StartDate = Date()
    var completionHandler:((String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnStartDate.action = {
            
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.year = 30
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            
            let datePicker = DatePickerDialog(textColor: .black,
                                              buttonColor: .red,
                                              font: UIFont.boldSystemFont(ofSize: 17),
                                              showCancelButton: true)
            datePicker.locale = Locale(identifier: UserDetails.shared.langauge)
            datePicker.show("",
                            doneButtonTitle: Language.get("OK"),
                            cancelButtonTitle: Language.get("Cancel"),
                            defaultDate:self.StartDate,
                            minimumDate: Date(),
                            maximumDate: maximumDate,
                            datePickerMode: .date) { (date) in
                if let dt = date {
                    self.StartDate = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, YYYY"
                    self.txtStartDate.text = formatter.string(from: dt)

                }
            }
        }
        self.btnClose.action = {
            self.dismiss(animated: true, completion: nil)
        }
        self.btnClose1.action = {
            self.dismiss(animated: true, completion: nil)
        }
        self.btnConfirm.action = {
            if self.txtStartDate.text == ""{
                self.displayAlertMsg(string: "Please select start date")
            }else{
                CommonAPI.shared.rescheduleshootingplan(parameters: [CWeb.reschedule_date:self.StartDate.toString(format: "yyyy-MM-dd",identifier: TimeZone(abbreviation: "UTC")!),CWeb.shooting_plan_resource_id:self.object.id]) { data in
                    self.completionHandler?(data["reschedule_date"] as? String ?? "")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
