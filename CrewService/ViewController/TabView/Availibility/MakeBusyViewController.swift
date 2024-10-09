//
//  MakeBusyViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 11/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class MakeBusyViewController: UIViewController {

    var provider:ProviderModel = ProviderModel()
    @IBOutlet weak var btnStartDate: AGButton!
    @IBOutlet weak var btnEndDate: AGButton!
    
    @IBOutlet var txtStartDate:UnderLineTextField!
    @IBOutlet var txtEndDate:UnderLineTextField!
    
    @IBOutlet weak var btnConfirm: AGButton!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnClose1: AGButton!
    var StartDate = Date()
    var EndDate = Date()
    var completionHandler:(()->Void)?
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
                    self.EndDate = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, YYYY"
                    self.txtStartDate.text = formatter.string(from: dt)
                    self.txtEndDate.text = formatter.string(from: self.EndDate)
                    
                }
            }
        }
        self.btnEndDate.action = {
            if self.txtEndDate.text == ""{
                AGAlertBuilder(withAlert: nil, message:Language.get("Please select start date first"))
                    .defaultAction(with: Language.get("OK"), handler: { _ in
                        
                    })
                    .show()
                return
            }
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.year = 30
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            let minDate = self.StartDate
            let datePicker = DatePickerDialog(textColor: .black,
                                              buttonColor: .red,
                                              font: UIFont.boldSystemFont(ofSize: 17),
                                              showCancelButton: true)
            datePicker.locale = Locale(identifier: UserDetails.shared.langauge)
            datePicker.show("",
                            doneButtonTitle: Language.get("OK"),
                            cancelButtonTitle:Language.get("Cancel"),
                            defaultDate:self.EndDate,
                            minimumDate: minDate,
                            maximumDate: maximumDate,
                            datePickerMode: .date) { (date) in
                if let dt = date {
                    self.EndDate = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, YYYY"
                    self.txtEndDate.text = formatter.string(from: dt)
                    
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
            }else if self.txtEndDate.text == ""{
                self.displayAlertMsg(string: "Please select end date")
            }else{
                CommonAPI.shared.addbusyslot(parameters: [CWeb.start_date:self.StartDate.toString(format: "yyyy-MM-dd",identifier: TimeZone(abbreviation: "UTC")!),CWeb.end_date:self.EndDate.toString(format: "yyyy-MM-dd",identifier: TimeZone(abbreviation: "UTC")!),CWeb.provider_profile_id:self.provider.id]) { data in
                    self.completionHandler?()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }
}
