//
//  FeedScreen.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

struct FeedScreen: View {
    
    @EnvironmentObject var feedViewModel: FeedViewModel
    @State var shareGif: Gif? = nil
    
    var body: some View {
        CollectionView(array: feedViewModel.gifs)
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
                [unowned feedViewModel] in
                feedViewModel.getFeed()
            }
            .sheet(item: $shareGif) { gif in
                ActivityView(activityItem: gif)
            }
    }
    
}
