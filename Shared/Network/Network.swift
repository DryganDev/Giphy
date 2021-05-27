//
//  NetworkModel.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 1.05.21.
//

import Foundation
import Combine

// make UI Status
final class Network {
    
    static let shared = Network()
    
    private init() {}
    
    private let session = URLSession(configuration: .default)
    
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
