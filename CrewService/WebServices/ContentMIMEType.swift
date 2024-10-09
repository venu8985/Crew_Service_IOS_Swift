//
//  ContentMIMEType.swift
//  Dumps
//
//  Created by Ashvin Gudaliya on 05/09/20.
//  Copyright © 2020 Nirav. All rights reserved.
//

import UIKit

protocol UploadDetails { }

struct ImageUploadData: UploadDetails {
    var fileName: String
    var key: String
    var type: ContentMIMEType
    var data: Data?
}

struct VideoUploadURL: UploadDetails {
    var fileName: String
    var key: String
    var type: ContentMIMEType
    var url: URL?
    
    func getFileName() -> String {
        return url?.lastPathComponent ?? fileName
    }
    
    func getFileExtension() -> ContentMIMEType {
        if let exten = (url?.lastPathComponent ?? fileName).split(separator: ".").last {
            return ContentMIMEType(rawValue: "video/\(exten)")
        } else {
            return type
        }
    }
}

struct ContentMIMEType: RawRepresentable, Hashable, Equatable {
    
    public var rawValue: String
    public typealias RawValue = String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var hashValue: Int { return rawValue.hashValue }
    public static func == (lhs: ContentMIMEType, rhs: ContentMIMEType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    // Images
    
    /// Bitmap
    static public let bmp = ContentMIMEType(rawValue: "image/bmp")
    /// Graphics Interchange Format photo
    static public let gif = ContentMIMEType(rawValue: "image/gif")
    /// JPEG photo
    static public let jpeg = ContentMIMEType(rawValue: "image/jpeg")
    /// Portable network graphics
    static public let png = ContentMIMEType(rawValue: "image/png")
    
    // Audio & Video
    
    /// MPEG Audio
    static public let mpegAudio = ContentMIMEType(rawValue: "audio/mpeg")
    /// MPEG Video
    static public let mpeg = ContentMIMEType(rawValue: "video/mpeg")
    /// MPEG4 Audio
    static public let mpeg4Audio = ContentMIMEType(rawValue: "audio/mp4")
    /// MPEG4 Video
    static public let mpeg4 = ContentMIMEType(rawValue: "video/mp4")
    /// OGG Audio
    static public let ogg = ContentMIMEType(rawValue: "audio/ogg")
    /// Advanced Audio Coding
    static public let aac = ContentMIMEType(rawValue: "audio/x-aac")
    /// Microsoft Audio Video Interleaved
    static public let avi = ContentMIMEType(rawValue: "video/x-msvideo")
    /// Microsoft Wave audio
    static public let wav = ContentMIMEType(rawValue: "audio/x-wav")
    /// Apple QuickTime format
    static public let quicktime = ContentMIMEType(rawValue: "video/quicktime")
    /// 3GPP
    static public let threegp = ContentMIMEType(rawValue: "video/3gpp")
    /// Adobe Flash video
    static public let flashVideo = ContentMIMEType(rawValue: "video/x-flv")
    /// Adobe Flash video
    static public let flv = ContentMIMEType.flashVideo
    
    static public let mov = ContentMIMEType(rawValue: "video/mov")
    static public let mp4 = ContentMIMEType(rawValue: "video/mp4")
}
