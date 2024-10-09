//
//  ReviewPopupVC.swift
//  Crew
//
//  Created by sanju on 27/10/21.
//

import UIKit

class ReviewPopupVC: UIViewController {
    @IBOutlet weak var dissmiss: UIButton!
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dissmissButton.addTarget(self, action: #selector(dissmissButtonAction(_:)), for: .touchUpInside)
        dissmiss.addTarget(self, action: #selector(dissmissButtonAction(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        bgView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    @objc func dissmissButtonAction(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .clear
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)        
    }
    
    
    
    
    

}


extension UIView {
func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
}
}
