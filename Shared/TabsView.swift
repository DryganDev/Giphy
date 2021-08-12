//
//  TabsView.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

struct TabsView: View {
    
    struct ListItem: Identifiable, Hashable {
        let id = UUID()
        let title: String
    }
    
    @State var selectTab: Int = 0
    
    let screens = [ListItem(title: "Feed"), ListItem(title: "Favorites")]
    @State var selectedItem: ListItem?
    
    init() {
        selectedItem = screens.first
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationView {
                List(screens, selection: $selectedItem) {
                    screen in
                    switch screen.title {
                        case "Feed":
                            NavigationLink(LocalizedStringKey(screen.title),
                                           destination: FeedScreen().modifier(Search()))
                        case "Favorites":
                            NavigationLink(LocalizedStringKey(screen.title),
                                           destination: FavoritesScreen().modifier(Search()))
                        default:
                            preconditionFailure("Should be")
                    }
                }
                .navigationTitle(LocalizedStringKey("Tabs"))
                FeedScreen().modifier(Search())
            }
            .navigationViewStyle(.columns)
        } else {
            TabView(selection: $selectTab) {
                FeedScreen()
                    .modifier(NavSearch())
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text(LocalizedStringKey("Feed"))
                    }
                    .tag(0)
                NavigationView {
                    FavoritesScreen()
                }
                .tabItem {
                    Image(systemName: "star")
                    Text(LocalizedStringKey("Favorites"))
                }
                .tag(1)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
