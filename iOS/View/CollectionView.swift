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
    
    private var array: [Datum]
    var selectedGif: ((Datum) -> Void)?
    
    init(array: [Datum], selection: ((Datum) -> Void)?) {
        self.array = array
        self.selectedGif = selection
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = CustomCollectionLayout(colomns: Constant.colomns)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.register(UINib(nibName: GifViewCell.id, bundle: nil),
                      forCellWithReuseIdentifier: GifViewCell.id)
        let dataSource = UICollectionViewDiffableDataSource<Section, Datum>(collectionView: view) {
            view, indexPath, object in
            cell.backgroundColor = .red
            let cell = view.dequeueReusableCell(withReuseIdentifier: GifViewCell.id, for: indexPath) as! GifViewCell
            return cell
        }
        context.coordinator.dataSource = dataSource
        view.delegate = context.coordinator
        compose(dataSource)
        return view
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        let dataSource = context.coordinator.dataSource
        compose(dataSource)
        
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.selectedGif = selectedGif
        return coordinator
    }

    class Coordinator: NSObject, UICollectionViewDelegate {
        
        var dataSource: UICollectionViewDiffableDataSource<Section, Datum>? = nil
        var selectedGif: ((Datum) -> Void)?
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            selectedGif?(item)
        }
        
    }
    
    func compose(_ dataSource: UICollectionViewDiffableDataSource<Section, Datum>?) {
        guard let dataSource = dataSource else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Datum>()
        snapshot.appendSections([.first])
        snapshot.appendItems(array)
        dataSource.apply(snapshot)
    }
    
    enum Section {
        case first
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(array: [], selection: nil)
    }
}
