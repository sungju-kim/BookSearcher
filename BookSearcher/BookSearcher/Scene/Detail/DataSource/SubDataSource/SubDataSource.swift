//
//  SubDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit

protocol SubDataSource {
    associatedtype ViewModelType
    var section: NSCollectionLayoutSection { get }
    var count: Int { get }
    var viewModel: ViewModelType? { get }
    func dequeCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func reusableView(from collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    func configure(with viewModel: any SectionViewModel)
}

extension SubDataSource {
    func reusableView(from collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}

protocol PlaneDataSource {}

extension PlaneDataSource {
    var section: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitem: item,
                                                       count: 1)

        let section = NSCollectionLayoutSection(group: group)

        return section
   }
}
