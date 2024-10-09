//
//  Image.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit
import AVFoundation

public enum AGImage: String {

    case ic_projects_projets
    case ic_releases_communiques
    case ic_teachings_enseignements
    case ic_friend_default
    case ic_new_group_default
    case ic_guide_image

    case ic_newsfeed_share
    case ic_newsfeed_comment
    case ic_newsfeed_like
    
    case ic_tariqa_pictures
    case ic_tariqa_sounds
    case ic_tariqa_documents
    case ic_tariqa_video
    case ic_right_arrow
   
    case ic_contact_us
    case ic_block_friend
    case ic_logout
    case ic_term_and_condition
    case ic_friendship_request
    case ic_edit_profile
    
    case ic_slider_thum
    case ic_dropdown_arrow
    
    case ic_is_not_friend
    case ic_is_friend
    case ic_serach_result_back
    case ic_plus_newsfeed
    
    case ic_create_group_right
    case ic_pencle_icon
    case ic_close_popup
    
    case ic_chat_profile
    case ic_gallery_profile
    case ic_share_profile

    case ic_comment_plus
    case ic_send_message_btn
    
    var img: UIImage {
        return UIImage(named: self.rawValue)!
    }
}

extension UIImage {
    
    /**
     Calculates the best height of the image for available width.
     */
    public func height(forWidth width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
    
    public func width(forHeight height: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: CGFloat(MAXFLOAT),
            height: height
        )
        
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.width
    }
}
