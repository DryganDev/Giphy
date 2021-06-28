//
//  ImageDownloader.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 26.06.21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case error(String)
}

final class ImageDownloader {
    
    private var executeQueue: OperationQueue = OperationQueue()
    private let table: NSMapTable<NSURL, Operation> = .init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    func startDownload(url: URL, network: Network) -> AnyPublisher<ImageContainer, Never> {
        let asyncOperation = ImageLoadingOperation(url: url, networkService: network)
        let publisher = asyncOperation
            .keyValueObservationPublisher(for: \.isFinished)
            .filter { $0 == .notInitial(old: false, new: true) }
            .map {
                [unowned asyncOperation] _ in
                ImageContainer(image: asyncOperation.data,
                               networkUrl: asyncOperation.networkUrl,
                               error: asyncOperation.error,
                               localUrl: asyncOperation.localUrl)
                
            }
            .eraseToAnyPublisher()
        executeQueue.addOperation(asyncOperation)
        table.setObject(asyncOperation, forKey: url as NSURL)
        return publisher
    }
    
    func stopDownload(url: URL) {
        table.object(forKey: url as NSURL)?.cancel()
    }
    
}
