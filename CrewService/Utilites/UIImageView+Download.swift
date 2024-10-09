//
//  UIImageView+Download.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit
import SDWebImage

enum ImageType: String {
    case error_image = "error_image"
    case no_image = ""
    case profile = "ic_friend_default"
    case ic_new_group_default
    case basicProfile = "ic_user_basic_pic"
    case cover = "ic_newsfeed_temp"
    case coverEditPro = "ic_edit_profile_backgroud"
    case newsfeed = "ic_default_newsfeed"
}

extension UIImageView {
    
    typealias AGImageManagerProgressBlock = (_ receivedSize: NSInteger ,_ expectedSize: NSInteger , _ url: URL?) -> Void
    typealias AGImageManagerCompletionBlock = (_ image: UIImage?  ,_ url: URL? ,_ success: Bool ,_ error: Error?) -> Void
    
    func setImageFor(with imageURL: String, placeholder: ImageType = .no_image) {
        
        if imageURL.isNull {
            self.image = UIImage(named: placeholder.rawValue)
            self.cancelImageRequest()
            return
        }
        
        let completionBlock: SDExternalCompletionBlock = { (tempImage, error, cacheType, imageURL) in
            if let downLoadedImage = tempImage {
                if cacheType == .none {
                    self.alpha = 0
                    UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: { () -> Void in
                        self.image = downLoadedImage
                        self.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
        if !imageURL.isNull,
            let url = imageURL.url {
            
            let plachImage = UIImage(named: placeholder.rawValue)
            self.sd_setImage(with: url, placeholderImage: plachImage, options: [.highPriority, .cacheMemoryOnly], progress: nil, completed: completionBlock)
        }
        else{
            self.image = UIImage(named: placeholder.rawValue)
        }
    }
    
    func cancelImageRequest() {
        self.sd_cancelCurrentImageLoad()
    }
    
    static func imageFromMemory(for url: String) -> UIImage? {
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded) {
            let manager = SDWebImageManager.shared()
            if let key: String = manager.cacheKey(for: url),
                let image = manager.imageCache?.imageFromMemoryCache(forKey: key) {
                return image
            }
        }
        return nil
    }
    
    class Cache{
        class func clear() {
            SDWebImageManager.shared().imageCache?.clearMemory()
            SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: nil)
        }
    }
    
    func mirrorImage(orientation: UIImage.Orientation) {
        if let cgImage = self.image?.cgImage, let scale = self.image?.scale {
            let image: UIImage = UIImage.init(cgImage: cgImage, scale: scale, orientation: orientation)
            self.image = image
        }
    }
    
    class func download(from url: URL, completionHandler: ((UIImage?) -> Void)? = nil) {
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            
            DispatchQueue.main.async {
                completionHandler?(image)
            }
            }.resume()
    }
}

extension String {
    var url: URL? {
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return URL(string: self)
        }
        return URL(string: encoded) ?? URL(string: self)
    }
}

extension URL {
    func clearCache(complation: @escaping SDWebImageNoParamsBlock) {
        let manager = SDWebImageManager.shared()
        if let key = manager.cacheKey(for: self) {
            manager.imageCache?.removeImage(forKey: key, withCompletion: complation)
        }
    }
    
    func saveImage(toCache: UIImage?, complation: @escaping SDWebImageNoParamsBlock) {
        guard let toCache = toCache else { return }
    
        let manager = SDWebImageManager.shared()
        if let key = manager.cacheKey(for: self) {
            manager.imageCache?.store(toCache, forKey: key, completion: complation)
        }
    }
}
