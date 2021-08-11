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
    @State var selectedRow: Row?
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            SplitViewController(master: { MasterScreen(selectedRow: $selectedRow) },
                                detail: { Detail1Screen(selectedRow: $selectedRow) })
        } else {
            TabView(selection: $selectTab) {
                FeedScreen()
                    .modifier(NavSearch())
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(LocalizedStringKey("Feed"))
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

enum Row: String, CaseIterable, Identifiable {
    
    var id: UUID { UUID() }
    
    case feed = "Feed"
    case favorite = "Favorite"
    
    var localized: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct MasterScreen: View {
    
    @Binding var selectedRow: Row?
    
    var body: some View {
        NavigationView {
            List(Row.allCases) {
                row in
                Button(row.localized) {
                    selectedRow = row
                }
                .foregroundColor(Color.black)
            }
            .navigationTitle(LocalizedStringKey("Tabs"))
        }
    }
}

struct Detail1Screen: View {
    
    @Binding var selectedRow: Row?
    
    var body: some View {
        switch selectedRow {
            case .feed:
                FeedScreen()
                    .modifier(Search())
                    .navigationTitle(selectedRow?.localized ?? "")
                
            case .favorite:
                FavoritesScreen()
                    .navigationTitle(selectedRow?.localized ?? "")
            default:
                Text("Nothing Selected")
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
