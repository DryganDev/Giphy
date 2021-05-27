//
//  FeedViewModel.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case requestCreating
}

protocol FeedViewModelProtocol: ObservableObject {
    
    var error: Error? { get set }
    var isLoading: Bool { get set }
    var gifs: [Datum] { get set }
    
    func getFeed()
}


final class FeedViewModel: FeedViewModelProtocol {
    
    private let networkModel: NetworkModelProtocol
    
    private var data: [GyphyData] = [] {
        didSet {
            data.forEach {
                gifs.append(contentsOf: $0.data)
            }
        }
    }
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var gifs: [Datum] = []
    
    private var cancelations: Set<AnyCancellable> = .init()
    
    init(networkModel: NetworkModelProtocol) {
        self.networkModel = networkModel
        networkModel.feedSubject
            .map { data in
                return data.flatMap{$0.data}
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        self?.error = error
                    case .finished: break
                }
            }, receiveValue: { [weak self] value in
                self?.isLoading = false
                self?.gifs = value
            })
            .store(in: &cancelations)
    }
    // MARK: - Feed
    func getFeed() {
        isLoading = true
        networkModel
            .loadFeed()
    }
        
}
