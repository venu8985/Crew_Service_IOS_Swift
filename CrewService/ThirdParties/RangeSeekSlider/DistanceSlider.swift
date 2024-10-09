//
//  DistanceSlider.swift
//  Alfayda
//
//  Created by Wholly-iOS on 11/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

class AGSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = 10 //added height for desired effect
        return result
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0/*Set_0_value_to_center_thumb*/, dy: 0)
    }
}

class DistanceSlider: UISlider {
    
    var thumbTextLabel: UILabel = UILabel()
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        thumbTextLabel.text = Int(value).description + "km"
        thumbTextLabel.font = UIFont.poppinsFont(size: 12, weight: .Regular)
        let newFrem = CGRect(x: thumbFrame.origin.x, y: thumbFrame.origin.y - 3 - self.thumbTextLabel.frame.height, width: 50, height: 20)
        thumbTextLabel.frame = newFrem
        thumbTextLabel.sizeToFit()
        thumbTextLabel.center.x = thumbFrame.origin.x + (thumbFrame.width / 2)
        thumbTextLabel.textColor = UIColor.Friend.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }
}
