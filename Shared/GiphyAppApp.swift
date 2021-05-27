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
        WindowGroup {
            TabsView()
                .environmentObject(FeedViewModel(networkModel: NetworkModel()))
        }
    }
}
