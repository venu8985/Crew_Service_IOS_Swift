//
//  WebViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 14/06/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

enum TypePage{
    case aboutuse
    case pp
    case tc
}
class WebViewController: UIViewController {

    @IBOutlet weak var lblText: UILabel!
    var type:TypePage = .aboutuse
    override func viewDidLoad() {
        super.viewDidLoad()
        lblText.text = ""
        if type == .aboutuse{
            self.title = Language.get("About Us")
        }else if type == .pp{
            self.title = Language.get("Privacy Policy")
        }else if type == .tc{
            self.title = Language.get("Terms & Conditions")
        }
        
        if type == .aboutuse{
            CommonAPI.shared.aboutus(parameters: [:], isShow: true) { data in
                if let text = data["about_us"] as? String{
                    self.setupData(text: text)
                }
            }
        }else if type == .pp{
            CommonAPI.shared.privacypolicy(parameters: [:]) { data in
                if let text = data["privacy_policy"] as? String{
                    self.setupData(text: text)
                }
            }
        }else if type == .tc{
            CommonAPI.shared.termsconditions(parameters: [:]) { data in
                if let text = data["terms_conditions"] as? String{
                    self.setupData(text: text)
                }
            }
        }
    }
    func setupData(text:String){
        
        let htmlFile = Bundle.main.path(forResource: "CustomHTMLView", ofType: "html")
        if let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8){
            var stringAttributed = htmlString
            if UserDetails.shared.langauge != "en"{
                stringAttributed = stringAttributed.replacingOccurrences(of: "text-align: center;", with: "text-align: right;")
            }else{
                stringAttributed = stringAttributed.replacingOccurrences(of: "text-align: center;", with: "text-align: left;")
            }
            lblText.attributedText = stringAttributed.replacingOccurrences(of: "Message_Guarav", with: text).htmlToAttributedString
        }
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

