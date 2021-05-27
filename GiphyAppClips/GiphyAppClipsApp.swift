//
//  GiphyAppClipsApp.swift
//  GiphyAppClips
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

@main
struct GiphyAppClipsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
