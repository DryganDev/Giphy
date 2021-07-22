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
    
    private var cancelation = AnyCancellable({})
    
    private var sourceGifs: [Gif] {
        !searchViewModel.searchText.isEmpty ? searchViewModel.searchGifs : feedViewModel.gifs
    }
    
    var body: some View {
        NavigationView {
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
                    gif in
                    print(gif)
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
                .sheet(item: $shareGif) { gif in
                    ActivityView(activityItem: gif)
                }
            
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(LocalizedStringKey("Feed"))
        }
        .searchable(text: $searchViewModel.searchText,
                    placement: .automatic,
                    prompt: "Gifs") {
            ForEach(searchViewModel.searchResults, id: \.self) {
                result in
                Text("\(result)").searchCompletion(result)
            }
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
