//
//  GifViewCell.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import UIKit
import Combine

final class GifViewCell: UICollectionViewCell {
    
    static let id = String(describing: GifViewCell.self)
    
    @IBOutlet private var imageView: UIImageView!
    
    private var cancelable = Set<AnyCancellable>()
    
    func setGif(_ gif: Gif) {
        cancelable.forEach{ $0.cancel() }
        gif.isLoading
            .sink {
                [weak self] isLoading in
                if isLoading {
                    self?.imageView.image = UIImage(systemName: "xmark.octagon")
                }
                else {
                    if let data = gif.image,
                       let image = UIImage.gifImageWithData(data) {
                        self?.imageView.image = image
                    }
                }
            }
            .store(in: &cancelable)
    }
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutIfNeeded()
        
//        imageView.preferredMaxLayoutWidth = imageView.bounds.size.width
//        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        layoutAttributes.bounds.size.height = 400
//            imageView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return layoutAttributes
//    }

    // Alternative implementation
    /*
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        label.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    */

}
