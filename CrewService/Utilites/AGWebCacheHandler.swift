//
//  AGWebCacheHandler.swift
//  Alfayda
//
//  Created by Wholly-iOS on 14/11/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit
import SDWebImage

typealias AGWebCacheImageSaveHandler = ((UIImage?) -> ())

class AGWebCacheHandler {
    
    static let shared = AGWebCacheHandler()
    
    func saveImage(inMemory toCache: UIImage?, url: URL? , complation: AGWebCacheImageSaveHandler? = nil) {
        
        guard let toCache = toCache else { return }
        guard let toUrl = url else { return }
        
        AGWebCacheHandler.shared.saveImage(inMemory: toCache, url: toUrl, complation: complation)
    }
    
    func saveImage(inMemory toCache: UIImage?, url: String? , complation: AGWebCacheImageSaveHandler? = nil) {
        
        guard let toCache = toCache else { return }
        guard let toUrl = url?.toUrl else { return }
        
        AGWebCacheHandler.shared.saveImage(inMemory: toCache, url: toUrl, complation: complation)
    }
    
    func saveImage(inMemory toCache: UIImage, url: URL , complation: AGWebCacheImageSaveHandler? = nil) {
        
        if let key = url.sdImageCacheKey {
            SDWebImageManager.shared().imageCache?.store(toCache, forKey: key, completion: {
                complation?(AGWebCacheHandler.shared.getImage(fromMemory: url.absoluteString))
            })
        }
    }
    
    func getImage(fromMemory url: String) -> UIImage? {
        if let key = url.toUrl?.sdImageCacheKey {
            
            if let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: key) {
                return image
            }
        }
        return nil
    }
}

extension UIImage {
    func saveToCache(for url: URL?, complation: @escaping AGWebCacheImageSaveHandler) {
        AGWebCacheHandler.shared.saveImage(inMemory: self, url: url, complation: complation)
    }
}

extension URL {
    func saveImageToCache(for image: UIImage, complation: @escaping AGWebCacheImageSaveHandler) {
        AGWebCacheHandler.shared.saveImage(inMemory: image, url: self, complation: complation)
    }
    
    var sdImageCacheKey: String? {
        return SDWebImageManager.shared().cacheKey(for: self)
    }
}

extension String {
    
    var toUrl: URL? {
        if let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded) {
            return url
        }
        return nil
    }
}
