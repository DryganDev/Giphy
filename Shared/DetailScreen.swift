//
//  DetailScreen.swift
//  DetailScreen
//
//  Created by Artsiom Sazonau on 2.08.21.
//

import SwiftUI

struct DetailScreen: View {
    
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    var body: some View {
        VStack {
            Text(feedViewModel.selectedGif?.meta.username ?? "")
            GifView(gif: feedViewModel.selectedGif)
            Spacer()
        }
    }
}
