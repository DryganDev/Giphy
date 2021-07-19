//
//  Gif.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 18.06.21.
//

import Foundation
import Combine
import SwiftUI

final class Gif: Hashable, Identifiable {
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        lhs.meta == rhs.meta
        && lhs.image == rhs.image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(meta)
        hasher.combine(image)
    }
    
    let meta: Datum
    let isLoading: CurrentValueSubject<Bool,Never> = .init(false)
    var image: Data?
    var error: Error?
    
    init(meta: Datum) {
        self.meta = meta
    }
}
