//
//  ImageCacheModel.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 2.06.21.
//

import Foundation
import Combine
import ImageService
// Reachability

protocol ImageCacheModelProtocol: AnyObject {
    
    func startLoading(_ gif: Gif, by url: URL)
    func stopLoading(_ gif: Gif, by url: URL?)
    
}

enum Status {
    case isLoading(Gif)
    case success(Gif)
    case error(Gif)
}

final class ImageCacheModel: ImageCacheModelProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    
    private var gifs: [Gif] = .init()
    
    init() {
        ImageCacheService.shared.subject
            .receive(on: DispatchQueue.main)
            .sink {
                [unowned self] image in
                guard let first = self.gifs.first(where: { $0.meta.images.fixedWidth?.url == image.networkUrl?.absoluteString }) else {
                    return
                }
                if image.image != nil || image.error != nil {
                    first.image = image.image
                    first.error = image.error
                    self.stopLoading(first, by: image.networkUrl)
                }
            }
            .store(in: &cancellable)
    }
    
    func startLoading(_ gif: Gif, by url: URL) {
        if gif.image == nil || gif.error == nil {
            gifs.append(gif)
            gif.isLoading.send(true)
            ImageCacheService.shared.startLoading(url: url, network: Network.shared)
        }
    }
    
    func stopLoading(_ gif: Gif, by url: URL?) {
        guard let url = url else {
            return
        }
        ImageCacheService.shared.stopLoading(url: url)
        gif.isLoading.send(false)
        gifs.removeAll { $0 == gif }
    }
    
}

extension Network: ImageService.Network {
    
}
