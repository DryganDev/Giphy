//
//  FeedScreen.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI
import Combine

struct FeedScreen: View {
    
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var shareGif: Gif? = nil
    
    @State var isDetailPresented: Bool = false
    
    private var cancelation = AnyCancellable({})
    
    private var sourceGifs: [Gif] {
        !searchViewModel.searchText.isEmpty ? searchViewModel.searchGifs : feedViewModel.gifs
    }
    
    var body: some View {
        CollectionView(array: sourceGifs)
            .willDisplay {
                [unowned feedViewModel] gif in
                feedViewModel.startLoading(gif)
            }
            .didEndDisplayin {
                [unowned feedViewModel] gif in
                feedViewModel.stopLoading(gif)
            }
            .select {
                [unowned feedViewModel] gif in
                feedViewModel.selectedGif = gif
                isDetailPresented = true
            }
            .removeItem {
                [unowned feedViewModel] gif in
                feedViewModel.gifs.removeAll{ $0 == gif }
            }
            .saveItem {
                gif in
            }
            .shareItem {
                gif in
                guard gif.image != nil else {
                    return
                }
                shareGif = gif
            }
            .sheet(item: $shareGif) { gif in
                ActivityView(activityItem: gif)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey("Feed"))
            .overlay {
                NavigationLink(destination: DetailScreen(), isActive: $isDetailPresented) {
                    EmptyView()
                }
            }
            .onAppear {
                [unowned feedViewModel, unowned searchViewModel] in
                feedViewModel.getFeed()
                feedViewModel.$gifs
                    .assign(to: \.gifs, on: searchViewModel)
                    .store(in: &searchViewModel.updateGifsCancelation)
            }
            .onDisappear {
                [unowned searchViewModel] in
                searchViewModel.updateGifsCancelation.removeAll()
            }
    }
    
}


struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        let searchVM = SearchViewModel()
        let feedViewModel = FeedViewModel(networkModel: NetworkModel(),
                                          imageCacheModel: ImageCacheModel())
        
        FeedScreen()
            .environmentObject(feedViewModel)
            .environmentObject(searchVM)
    }
}
