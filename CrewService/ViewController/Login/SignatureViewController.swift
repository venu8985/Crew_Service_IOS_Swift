//
//  SignatureViewController.swift
//  D-Kart
//
//  Created by Gaurav Gudaliya R on 08/01/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {

    @IBOutlet var btnClearPad:AGButton!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    var complitionHander:((UIImage,UIBezierPath)->Void)?
    var path = UIBezierPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnClearPad.action = {
            if let signatureImage = self.signatureView.getSignature(scale: 2) {
                self.complitionHander?(signatureImage,self.signatureView.path)
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: Language.get("Clear Signature"), style: .plain, target: self, action: #selector(btnBack)), animated: true)
        self.signatureView.injectBezierPath(path)
        self.signatureView.setNeedsDisplay()
    }
    
    @objc func btnBack(){
        self.signatureView.clear()
    }
}
