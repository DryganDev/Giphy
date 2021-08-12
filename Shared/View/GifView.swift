//
//  GifView.swift
//  GifView
//
//  Created by Artsiom Sazonau on 5.08.21.
//

import SwiftUI
import Combine
import UIKit

struct GifView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        return coordinator
    }
    
    class Coordinator {
        var imageView: UIImageView?
    }
    
    let gif: Gif?
    
    init(gif: Gif?) {
        self.gif = gif
    }
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        if let data = gif?.image, let image = UIImage.gifImageWithData(data) {
            imageView.image = image
        }
        context.coordinator.imageView = imageView
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard context.coordinator.imageView?.image != nil else {
            return
        }
        guard let data = gif?.image, let image = UIImage.gifImageWithData(data) else {
            return
        }
        context.coordinator.imageView?.image = image
    }
    
}
