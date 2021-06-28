//
//  CollectionView.swift
//  GiphyApp (iOS)
//
//  Created by Artsiom Sazonau on 30.04.21.
//

import UIKit
import SwiftUI

struct CollectionView: UIViewRepresentable {
    
    enum Constant {
        static let colomns = 2
    }
    
    enum Section: CaseIterable {
        case first
    }
    
    private var array: [Gif]
    private var selectedGif: ((Gif) -> Void)?
    private var willDisplay: ((Gif) -> Void)?
    private var didEndDisplaying: ((Gif) -> Void)?
    
    init(array: [Gif]) {
        self.array = array
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = CustomCollectionLayout(colomns: Constant.colomns)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.register(UINib(nibName: GifViewCell.id, bundle: nil),
                      forCellWithReuseIdentifier: GifViewCell.id)
        let dataSource = UICollectionViewDiffableDataSource<Section, Gif>(collectionView: view) {
            view, indexPath, object in
            let cell = view.dequeueReusableCell(withReuseIdentifier: GifViewCell.id, for: indexPath) as! GifViewCell
            cell.setGif(object)
            return cell
        }
        context.coordinator.dataSource = dataSource
        context.coordinator.array = array
        view.delegate = context.coordinator
        layout.delegate = context.coordinator
        compose(dataSource)
        return view
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        let dataSource = context.coordinator.dataSource
        context.coordinator.array = array
        compose(dataSource)
        
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.selectedGif = selectedGif
        coordinator.willDisplay = willDisplay
        coordinator.didEndDisplaying = didEndDisplaying
        return coordinator
    }

    class Coordinator: NSObject, UICollectionViewDelegate, CustomCollectionLayoutDelegate {
        
        var dataSource: UICollectionViewDiffableDataSource<Section, Gif>? = nil
        var selectedGif: ((Gif) -> Void)?
        var array: [Gif] = []
        var willDisplay: ((Gif) -> Void)?
        var didEndDisplaying: ((Gif) -> Void)?
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            selectedGif?(item)
        }
        
        func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return 0
            }
            return CGFloat(Int(item.meta.images.fixedWidth?.height ?? "") ?? 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsIn section: CollectionView.Section) -> Int {
            return array.count
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            willDisplay?(item)
        }
        
        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            didEndDisplaying?(item)
        }
        
    }
    
    func compose(_ dataSource: UICollectionViewDiffableDataSource<Section, Gif>?) {
        guard let dataSource = dataSource else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Gif>()
        snapshot.appendSections([.first])
        snapshot.appendItems(array)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func willDisplay(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.willDisplay = action
        return self
    }
    
    func didEndDisplayin(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.didEndDisplaying = action
        return self
    }
    
    func select(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.selectedGif = action
        return self
    }
    
}
