//
//  FeedViewModel.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import Combine
import Foundation

protocol FeedViewModelProtocol: ObservableObject {
    
    var error: Error? { get set }
    var isLoading: Bool { get set }
    var gifs: [Gif] { get set }
        
    func getFeed()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    private let networkModel: NetworkModelProtocol
    private let imageCacheModel: ImageCacheModelProtocol
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var gifs: [Gif] = []
    
    var selectedGif: Gif?
    
    private var cancelations: Set<AnyCancellable> = .init()
    
    init(networkModel: NetworkModelProtocol, imageCacheModel: ImageCacheModelProtocol) {
        self.networkModel = networkModel
        self.imageCacheModel = imageCacheModel
        networkModel.feedSubject
            .map {
                $0
                    .flatMap { $0.data }
                    .map { Gif(meta: $0) }
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        self?.error = error
                    case .finished: break
                }
            }, receiveValue: { [weak self] value in
                self?.gifs = value
                self?.isLoading = false
            })
            .store(in: &cancelations)
    }
    
    // MARK: - Feed
    func getFeed() {
        isLoading = true
        networkModel.loadFeed()
    }
    
    func startLoading(_ gif: Gif) {
        guard let urlString = gif.meta.images.fixedWidth?.url,
              let url = URL(string: urlString) else {
            fatalError()
        }
        imageCacheModel.startLoading(gif, by: url)
    }
    
    func stopLoading(_ gif: Gif) {
        guard let urlString = gif.meta.images.fixedWidth?.url,
              let url = URL(string: urlString) else {
            fatalError()
        }
        imageCacheModel.stopLoading(gif, by: url)
    }
        
}
