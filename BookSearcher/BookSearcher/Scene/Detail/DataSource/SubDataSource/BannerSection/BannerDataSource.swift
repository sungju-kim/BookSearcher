//
//  BannerDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class BannerDataSource: SubDataSource, PlaneDataSource {
    private(set) var viewModel: BannerSectionViewModel?
    var count: Int {
        return viewModel?.cellViewModels?.count ?? 0
    }

    func dequeCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier,
                                                            for: indexPath) as? BannerCell,
              let cellViewModel = viewModel?.cellViewModels?[indexPath.item] else { return UICollectionViewCell() }

        cell.configure(with: cellViewModel)
        return cell
    }

    func configure(with viewModel: any SectionViewModel) {
        guard let viewModel = viewModel as? BannerSectionViewModel else { return }
        self.viewModel = viewModel
    }
}
