//
//  UIBarButtonItem+Extension.swift
//  Alfayda
//
//  Created by Wholly-iOS on 22/10/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

class AGBadgeBarButton: UIBarButtonItem {
    
    // Badge value to be display
    var badgeValue : String = "" {
        didSet {
            if (self.badgeValue == "0" && self.shouldHideBadgeAtZero == true) || self.badgeValue.isEmpty {
                self.removeBadge()
            } else {
                self.badge.isHidden = false
                self.updateBadgeValueAnimated(animated: true)
            }
        }
    }
    
    // Badge background color
    var badgeBGColor = UIColor.darkGray {
        didSet{
            self.badge.backgroundColor = self.badgeBGColor
        }
    }
    
    // Badge text color
    var badgeTextColor = UIColor.white {
        didSet{
            self.badge.textColor = self.badgeTextColor
        }
    }
    
    // Badge font
    var badgeFont: UIFont = UIFont.boldSystemFont(ofSize: 12.0) {
        didSet{
            self.badge.font = self.badgeFont
        }
    }
    
    // Padding value for the badge
    var badgePadding: CGFloat = 2.0
    
    // Minimum size badge to small
    var badgeMinSize: CGFloat = 5
    
    //Values for offseting the badge over the BarButtonItem you picked
    var badgeOriginX : CGFloat = 0 {
        didSet {
            self.updateBadgeFrame()
        }
    }
    
    var badgeOriginY : CGFloat = 0 {
        didSet {
            self.updateBadgeFrame()
        }
    }
    
    var borderColor: UIColor = .clear {
        didSet {
            self.badge.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            self.badge.layer.borderWidth = self.borderWidth
        }
    }
    
    // In case of numbers, remove the badge when reaching zero
    var shouldHideBadgeAtZero = true
    
    // Badge has a bounce animation when value changes
    var shouldAnimateBadge = true
    
    // The badge displayed over the BarButtonItem
    var badge = UILabel()
    
    //MARK: - init
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: -
    func setup(customButton: UIButton) {
        
        self.customView = customButton
        self.customView?.clipsToBounds = false
        
        self.badge = UILabel(frame: CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: 0, height: 0))
        self.badge.textColor = self.badgeTextColor
        self.badge.backgroundColor = self.badgeBGColor
        self.badge.font = self.badgeFont
        self.badge.textAlignment = NSTextAlignment.center
        self.badge.text = ""
        self.customView?.addSubview(self.badge)
        self.updateBadgeValueAnimated(animated: true)
    }
    
    
    func updateBadgeFrame() {
        let lbl_Frame = duplicateLabel(lblCopy: self.badge)
        lbl_Frame.sizeToFit()
        
        let expectedLabelSize = lbl_Frame.frame.size
        
        var minHeight = expectedLabelSize.height
        minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height
        
        var minWidth = expectedLabelSize.width
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        let padding = self.badgePadding
        self.badge.frame = CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: minWidth + padding, height: minHeight + padding)
        self.badge.layer.cornerRadius = self.badge.frame.height / 2
        self.badge.layer.masksToBounds = true
    }
    
    func duplicateLabel(lblCopy: UILabel) -> UILabel {
        let lbl_duplicate = UILabel(frame: lblCopy.frame)
        lbl_duplicate.text = lblCopy.text
        lbl_duplicate.font = lblCopy.font
        
        return lbl_duplicate
    }
    
    func updateBadgeValueAnimated(animated : Bool) {
        if(animated == true && self.shouldAnimateBadge && self.badge.text != self.badgeValue) {
            let animation = CABasicAnimation .init(keyPath: "transform.scale")
            animation.fromValue = 1.5
            animation.toValue = 1
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction .init(controlPoints: 0.4, 1.3, 1, 1)
            self.badge.layer.add(animation, forKey: "bounceAnimation")
        }
        self.badge.text = self.badgeValue
        self.updateBadgeFrame()
    }
    
    @objc func removeBadge() {
        UIView.animate(withDuration: 0.3) {
            self.badge.isHidden = true
        }
    }
}
