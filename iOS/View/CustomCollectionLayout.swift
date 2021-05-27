//
//  CustomCollectionLayout.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import UIKit

@propertyWrapper
struct Colomn {
    
    var wrappedValue: Int
    
    init(wrappedValue: Int) {
        if wrappedValue < 1 {
            self.wrappedValue = 1
        } else {
            self.wrappedValue = wrappedValue
        }
    }
}

final class CustomCollectionLayout: UICollectionViewFlowLayout {
    @Colomn var colomns: Int
    
    required init(colomns: Int) {
        self.colomns = 1
        super.init()
        
        scrollDirection = .vertical
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = collectionView else { return layoutAttributes }

        let marginsAndInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(colomns - 1)
        layoutAttributes.bounds.size.width = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(colomns)).rounded(.down)

        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superLayoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return superLayoutAttributes }

        let layoutAttributes = superLayoutAttributes.compactMap { layoutAttribute in
            return layoutAttribute.representedElementCategory == .cell ? layoutAttributesForItem(at: layoutAttribute.indexPath) : layoutAttribute
        }

        // (optional) Uncomment to top align cells that are on the same line
        /*
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
            for attribute in attributes where attribute.size.height != max.size.height {
                attribute.frame.origin.y = max.frame.origin.y
            }
        }
         */

        // (optional) Uncomment to bottom align cells that are on the same line
        /*
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
            for attribute in attributes where attribute.size.height != max.size.height {
                attribute.frame.origin.y += max.frame.maxY - attribute.frame.maxY
            }
        }
         */

        return layoutAttributes
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        proposedContentOffset
//    }
//    open var minimumLineSpacing: CGFloat
//
//    open var minimumInteritemSpacing: CGFloat
//
//    open var itemSize: CGSize
//
//    @available(iOS 8.0, *)
//    open var estimatedItemSize: CGSize // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
//
//    open var scrollDirection: UICollectionView.ScrollDirection // default is UICollectionViewScrollDirectionVertical
//
//    open var headerReferenceSize: CGSize
//
//    open var footerReferenceSize: CGSize
//
//    open var sectionInset: UIEdgeInsets
//
//    
//    /// The reference boundary that the section insets will be defined as relative to. Defaults to `.fromContentInset`.
//    /// NOTE: Content inset will always be respected at a minimum. For example, if the sectionInsetReference equals `.fromSafeArea`, but the adjusted content inset is greater that the combination of the safe area and section insets, then section content will be aligned with the content inset instead.
//    @available(iOS 11.0, *)
//    open var sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference
//
//    
//    // Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).
//    @available(iOS 9.0, *)
//    open var sectionHeadersPinToVisibleBounds: Bool
//
//    @available(iOS 9.0, *)
//    open var sectionFootersPinToVisibleBounds: Bool
    
}

//import UIKit

//class FlowLayout: UICollectionViewFlowLayout {

//    let cellsPerRow: Int
//
//    required init(cellsPerRow: Int = 1, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
//        self.cellsPerRow = cellsPerRow
//
//        super.init()
//
//        self.minimumInteritemSpacing = minimumInteritemSpacing
//        self.minimumLineSpacing = minimumLineSpacing
//        self.sectionInset = sectionInset
//        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
//        guard let collectionView = collectionView else { return layoutAttributes }
//
//        let marginsAndInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
//        layoutAttributes.bounds.size.width = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
//
//        return layoutAttributes
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let superLayoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
//        guard scrollDirection == .vertical else { return superLayoutAttributes }
//
//        let layoutAttributes = superLayoutAttributes.compactMap { layoutAttribute in
//            return layoutAttribute.representedElementCategory == .cell ? layoutAttributesForItem(at: layoutAttribute.indexPath) : layoutAttribute
//        }
//
//        // (optional) Uncomment to top align cells that are on the same line
//        /*
//        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
//        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
//            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
//            for attribute in attributes where attribute.size.height != max.size.height {
//                attribute.frame.origin.y = max.frame.origin.y
//            }
//        }
//         */
//
//        // (optional) Uncomment to bottom align cells that are on the same line
//        /*
//        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
//        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
//            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
//            for attribute in attributes where attribute.size.height != max.size.height {
//                attribute.frame.origin.y += max.frame.maxY - attribute.frame.maxY
//            }
//        }
//         */
//
//        return layoutAttributes
//    }
//
//}
