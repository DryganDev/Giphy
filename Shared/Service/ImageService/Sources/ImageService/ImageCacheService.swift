//
//  ImageCacheService.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 6.06.21.
//

import Foundation
import Combine

public protocol Network {
        
    func requestImage(_ request: URLRequest) -> AnyPublisher<URL, Error>
    
}

public final class ImageCacheService {
    
    public static let shared = ImageCacheService()
        
    var cache: Cache<NSURL, ImageContainer> {
        imageCache.cache
    }
    
    public var subject = PassthroughSubject<ImageContainer, Never>()
    
    let imageCache = ImageCache()
    let imageDownloader = ImageDownloader()
    
    var cancelable = Set<AnyCancellable>()
    
    public func startLoading(url: URL, network: Network) {
        if let image = imageCache.getImage(by: url) {
            subject.send(image)
        } else {
            imageDownloader.startDownload(url: url, network: network)
                .sink {
                    [unowned self] image in
                    if let url = image.networkUrl {
                        self.cache.setObject(image, forKey: url as NSURL)
                    }
                    self.subject.send(image)
                }
                .store(in: &cancelable)
            
        }
    }
    
    public func stopLoading(url: URL) {
        imageDownloader.stopDownload(url: url)
    }
    
}

