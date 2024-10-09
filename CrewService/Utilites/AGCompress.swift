//
//  AGCompress.swift
//  Alfayda
//
//  Created by Wholly-iOS on 19/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit
import AVFoundation

class AGCompress: NSObject {
    
    public static var timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }

    public static func video(inputURL: URL, outputFileType: AVFileType = .mp4, handler: @escaping ((Data?, String, URL?) -> Void) ) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        let seconds = urlAsset.duration.seconds
        let timeDuration = String(format: "%02d:%02d", Int((seconds / 60).truncatingRemainder(dividingBy: 60)), Int(seconds.truncatingRemainder(dividingBy: 60)))
        
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil, timeDuration, nil)
            
            return
        }
        
        let compressedURL = AGCompress.fileFullUrl(filename: NSUUID().uuidString + AGCompress.timestamp)
        
        GGLog.debug("Files compressedURL url:-\(compressedURL.absoluteString)")
        
        exportSession.outputURL = compressedURL
        exportSession.outputFileType = outputFileType
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            do {
                let compressedData = try Data(contentsOf: compressedURL)
                AGCompress.removeItems(files: [compressedURL])
                handler(compressedData, timeDuration, compressedURL)
            }
            catch {
                handler(nil, timeDuration, compressedURL)
            }
        }
    }
    
    static func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func fileFullUrl(filename: String) -> URL {
        let filename = "\(filename).m4a"
        let filePath = documentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    public static func removeItems(files: [URL]) {
        files.forEach { file in
            DispatchQueue.global(qos: .utility).async {
                do {
                    try FileManager.default.removeItem(at: file)
                    GGLog.debug("File deleted:- \(file.absoluteString)")
                }
                catch {
                    GGLog.debug(error)
                }
            }
        }
    }
}
