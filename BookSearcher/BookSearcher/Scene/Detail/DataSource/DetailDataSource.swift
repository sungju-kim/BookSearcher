//
//  DetailDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class DetailDataSource: NSObject, UICollectionViewDataSource {
    private var subDataSources: [Int: any SubDataSource] = [0: BannerDataSource(),
                                                        1: ButtonDataSource(),
                                                        2: BookInfoDataSource(),
                                                        3: StarRateDataSource(),
                                                        4: ReviewDataSource()]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subDataSources[section]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let subDataSource = subDataSources[indexPath.section] else { return UICollectionViewCell() }
        return subDataSource.dequeCell(from: collectionView, at: indexPath)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subDataSources.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let subDataSource = subDataSources[indexPath.section] else { return UICollectionReusableView() }
        return subDataSource.reusableView(from: collectionView, kind: kind, at: indexPath)
    }
}

// MARK: - Configure

extension DetailDataSource {
    func sectionProvider(index: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let subDataSource = subDataSources[index] ?? BannerDataSource()

        return subDataSource.section
    }

    func configure(with viewModels: [any SectionViewModel]) {
        viewModels.enumerated().forEach { subDataSources[$0]?.configure(with: $1) }
    }
}
