//
//  ReviewDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit

final class ReviewDataSource: SubDataSource, HeaderDataSource {
    private(set) var viewModel: ReviewSectionViewModel?
    var count: Int {
        return viewModel?.cellViewModels?.count ?? 0
    }
    func dequeCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier,
                                                            for: indexPath) as? ReviewCell,
              let cellViewModel = viewModel?.cellViewModels?[indexPath.item] else { return UICollectionViewCell() }

        cell.configure(with: cellViewModel)
        return cell
    }

    func reusableView(from collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: CommonHeaderView.identifier,
                                                                               for: indexPath) as? CommonHeaderView else { return UICollectionReusableView() }
        headerView.configure(with: viewModel?.headerText)
        return headerView
    }

    func configure(with viewModel: any SectionViewModel) {
        guard let viewModel = viewModel as? ReviewSectionViewModel else { return }
        self.viewModel = viewModel
    }
}
