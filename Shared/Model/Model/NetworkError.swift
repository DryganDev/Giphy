//
//  NetworkError.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 18.06.21.
//

import Foundation

enum NetworkError: Error {
    case requestCreating
    case imageDownload(Error)
}
