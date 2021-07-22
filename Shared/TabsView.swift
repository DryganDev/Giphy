//
//  TabsView.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

struct TabsView: View {
    
    @State var selectTab: Int = 0
        
    var body: some View {
        TabView(selection: $selectTab) {
            FeedScreen()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(LocalizedStringKey("Feed"))
                }
                .tag(0)
            FavoritesScreen()
                .tabItem {
                    Image(systemName: "star")
                    Text(LocalizedStringKey("Favorites"))
                }
                .tag(1)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
