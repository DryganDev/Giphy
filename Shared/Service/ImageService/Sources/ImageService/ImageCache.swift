//
//  ImageCache.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 26.06.21.
//

import Foundation

class ImageCache {
    
    var cache = Cache<NSURL, ImageContainer>()
    
    func getImage(by url: URL) -> ImageContainer? {
        if let image = cache.object(forKey: url as NSURL) as? ImageContainer {
             return image
        } else {
            return nil
        }
    }
    
}
