//
//  SearchViewModel.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 4.07.21.
//

import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    var gifs: [Gif] = []
    
    var updateGifsCancelation: Set<AnyCancellable> = .init()
    
    private var cancelations: Set<AnyCancellable> = .init()
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return gifs.map { $0.meta.title }
        } else {
            return gifs
                .map { $0.meta.title }
                .filter { $0.contains(searchText) }
        }
    }
    
    var searchGifs: [Gif] {
        if searchText.isEmpty {
            return gifs
        } else {
            return gifs
                .filter{ $0.meta.title == searchText }
        }
    }
    
}
