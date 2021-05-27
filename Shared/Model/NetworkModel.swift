//
//  NetworkModel.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 19.05.21.
//

import Foundation
import Combine

protocol NetworkModelProtocol: AnyObject {
    var feedSubject: CurrentValueSubject<[GyphyData],Error> { get }
    func loadFeed()
}

final class NetworkModel: NetworkModelProtocol {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let network = Network.shared
    private let giphyRequestFactory = GiphyRequestFactory()
    
    var feedSubject: CurrentValueSubject<[GyphyData],Error> = .init([])
        
    func loadFeed() {
        
        guard let request = giphyRequestFactory.getTrendingRequest() else {
            fatalError("Request building fail")
        }
        network
            .request(request)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] completion in
                switch completion {
                    case let .failure(error):
                        self?.feedSubject.send(completion: .failure(error))
                    case .finished: break
                }
            } receiveValue: { [weak self] (data: GyphyData) in
                self?.feedSubject.send([data])
            }
            .store(in: &subscriptions)
    }
}

