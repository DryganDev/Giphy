//
//  FeedScreen.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 17.04.21.
//

import SwiftUI

struct FeedScreen: View {
    
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    var body: some View {
        CollectionView(array: feedViewModel.gifs) {
            gif in
            print(gif)
        }
        .onAppear {
            feedViewModel.getFeed()
        }
    }
    
}

struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen()
    }
}

//struct ActivityIndicator: UIViewRepresentable {
////    @Binding var isAnimating: Bool
//
//    func makeUIView(context: Context) -> UIActivityIndicatorView {
////        let v = UIActivityIndicatorView()
////
////        return v
//    }
//
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
////        if isAnimating {
////            uiView.startAnimating()
////        } else {
////            uiView.stopAnimating()
////        }
//    }
//}


