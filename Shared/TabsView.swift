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
            SearchScreen()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(LocalizedStringKey("Search"))
                }
                .tag(1)
            FavoritesScreen()
                .tabItem {
                    Image(systemName: "star")
                    Text(LocalizedStringKey("Favorites"))
                }
                .tag(2)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
