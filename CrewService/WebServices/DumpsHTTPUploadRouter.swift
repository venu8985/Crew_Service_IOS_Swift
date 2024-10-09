//
//  DumpsHTTPUploadRouter.swift
//  Dumps
//
//  Created by Ashvin Gudaliya on 05/09/20.
//  Copyright © 2020 Nirav. All rights reserved.
//

import UIKit
import Alamofire

enum DumpsHTTPUploadRouter: HTTPUploadRouter {

    case uploadVideo(ticket_id: String, title: String, imageDeatils: UploadDetails?, videoDetails: UploadDetails?)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadVideo:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .uploadVideo: return "imagesUpload"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .uploadVideo(let ticket_id, let title, let imageDeatils, let videoDetails):
            return ["ticket_id": ticket_id, "title": title, "imageDeatils": imageDeatils as Any, "videoDetails": videoDetails as Any]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
    
    func asURL() throws -> URL {
        return url
    }
}
