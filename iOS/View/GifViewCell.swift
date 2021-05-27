//
//  GifViewCell.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import UIKit

final class GifViewCell: UICollectionViewCell {
    
    static let id = String(describing: GifViewCell.self)
    
    @IBOutlet private var imageView: UIImageView!
    var gif: Datum?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .yellow
    }
    
    private func setGif(_ gif: Datum) {
        self.gif = gif
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutIfNeeded()
        
//        imageView.preferredMaxLayoutWidth = imageView.bounds.size.width
//        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        layoutAttributes.bounds.size.height = imageView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }

    // Alternative implementation
    /*
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        label.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    */

}
