//
//  BookInfoDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit

final class BookInfoDataSource: SubDataSource {
    private(set) var viewModel: BookInfoSectionViewModel?

    var count: Int {
        return viewModel?.cellViewModels?.count ?? 0
    }

    func dequeCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookInfoCell.identifier,
                                                            for: indexPath) as? BookInfoCell,
              let cellViewModel = viewModel?.cellViewModels?[indexPath.item]   else { return UICollectionViewCell() }

        cell.configure(with: cellViewModel)
        return cell
    }

    func reusableView(from collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: CommonHeaderView.identifier,
                                                                               for: indexPath) as? CommonHeaderView else { return UICollectionReusableView() }

        return headerView
    }

    func configure(with viewModel: any SectionViewModel) {
        guard let viewModel = viewModel as? BookInfoSectionViewModel else { return }
        self.viewModel = viewModel

    }
}

extension BookInfoDataSource {
    var section: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitem: item,
                                                       count: 1)

        let section = NSCollectionLayoutSection(group: group)

        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                          heightDimension: .estimated(100)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)]

        return section
   }
}
