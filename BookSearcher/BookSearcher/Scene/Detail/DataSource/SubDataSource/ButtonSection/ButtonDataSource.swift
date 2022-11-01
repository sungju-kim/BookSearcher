//
//  ButtonDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit

final class ButtonDataSource: SubDataSource, PlaneDataSource {
    private(set) var viewModel: ButtonSectionViewModel?

    var count: Int {
        return viewModel?.cellViewModels?.count ?? 0
    }

    func dequeCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier,
                                                            for: indexPath) as? ButtonCell,
              let cellViewModel = viewModel?.cellViewModels?[indexPath.item] else { return UICollectionViewCell() }

        cell.configure(with: cellViewModel)
        return cell
    }

    func configure(with viewModel: any SectionViewModel) {
        guard let viewModel = viewModel as? ButtonSectionViewModel else { return }
        self.viewModel = viewModel
    }
}
