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
        static let iosColomns = 2
        static let ipadColomns = 3
    }
    
    enum Section: CaseIterable {
        case first
    }
    
    private var array: [Gif]
    private var selectedGif: ((Gif) -> Void)?
    private var willDisplay: ((Gif) -> Void)?
    private var didEndDisplaying: ((Gif) -> Void)?
    private var removeItem: ((Gif) -> Void)?
    private var saveItem: ((Gif) -> Void)?
    private var shareItem: ((Gif) -> Void)?
    
    init(array: [Gif]) {
        self.array = array
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = CustomCollectionLayout(colomns: UIDevice.current.userInterfaceIdiom != .pad ? Constant.iosColomns : Constant.ipadColomns)
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
        coordinator.removeItem = removeItem
        coordinator.saveItem = saveItem
        coordinator.shareItem = shareItem
        return coordinator
    }

    class Coordinator: NSObject, UICollectionViewDelegate, CustomCollectionLayoutDelegate {
        
        var dataSource: UICollectionViewDiffableDataSource<Section, Gif>? = nil
        var selectedGif: ((Gif) -> Void)?
        var array: [Gif] = []
        var willDisplay: ((Gif) -> Void)?
        var didEndDisplaying: ((Gif) -> Void)?
        var removeItem: ((Gif) -> Void)?
        var saveItem: ((Gif) -> Void)?
        var shareItem: ((Gif) -> Void)?
        
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
        
        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
                
                let save = UIAction(title: "Save", image: UIImage(systemName: "square.and.arrow.down")) {
                    [unowned self] _ in
                    self.saveItem?(item)
                }
                
                let remove = UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) {
                    [unowned self] _ in
                    self.removeItem?(item)
                }
                
                let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) {
                    [unowned self] _ in
                    self.shareItem?(item)
                }
                
                return UIMenu(title: "Actions", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [save, share, remove])
            }
            return context
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
    
    func removeItem(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.removeItem = action
        return self
    }
    
    func saveItem(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.saveItem = action
        return self
    }
    
    func shareItem(action: @escaping (Gif) -> Void) -> CollectionView {
        var `self` = self
        self.shareItem = action
        return self
    }
    
}
