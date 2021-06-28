//
//  ImageContainer.swift
//  
//
//  Created by Artsiom Sazonau on 27.06.21.
//

import Foundation

public class ImageContainer {
    public var image: Data?
    public var networkUrl: URL?
    public var localUrl: URL?
    public var error: Error?
    
    init(image: Data? = nil, networkUrl: URL? = nil, error: Error? = nil, localUrl: URL? = nil) {
        self.image = image
        self.error = error
        self.networkUrl = networkUrl
        if let url = localUrl, url.isFileURL {
            self.localUrl = localUrl
        }
    }
}
