//
//  ImageLoadingOperation.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 6.06.21.
//

import Foundation
import Combine

final class ImageLoadingOperation: AsyncOperation {
    
    let imageUrl: URL
    private let networkService: Network
    var data: Data?
    var networkUrl: URL?
    var localUrl: URL?
    var error: Error?
    
    private var cancelable = Set<AnyCancellable>()
    
    init(url: URL, networkService: Network) {
        self.imageUrl = url
        self.networkService = networkService
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)

        self.downloadImage()
    }
    
    override func cancel() {
        super.cancel()
        
        cancelable.removeAll()
    }
    
    func downloadImage() {
        let request = URLRequest(url: imageUrl)
        networkService.requestImage(request)
            .tryMap {
                (try Data.init(contentsOf: $0), $0)
            }
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error): self?.error = error
                }
            } receiveValue: { [weak self] data in
                self?.data = data.0
                self?.localUrl = data.1
                self?.networkUrl = request.url
                self?.finish(true)
            }
            .store(in: &cancelable)
    }
    
}
