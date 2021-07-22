//
//  GiphyAppApp.swift
//  Shared
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

@main
struct GiphyAppApp: App {
    let persistenceController = PersistenceController.preview
    
    var body: some Scene {
        let searchVM = SearchViewModel()
        let feedViewModel = FeedViewModel(networkModel: NetworkModel(),
                                          imageCacheModel: ImageCacheModel())
        WindowGroup {
            TabsView()
                .environmentObject(feedViewModel)
                .environmentObject(searchVM)
        }
    }
    
}
