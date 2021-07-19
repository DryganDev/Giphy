//
//  ActivityView.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 28.06.21.
//

import UIKit
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {

    var activityItem: Gif

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let imageData = activityItem.image ?? Data()
        let image = UIImage.gifImageWithData(imageData) ?? UIImage()
            
        let text = activityItem.meta.title
        
        let controller = UIActivityViewController(activityItems: [image,text], applicationActivities: [])
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}

}
