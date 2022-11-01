//
//  DetailDataSource.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class DetailDataSource: NSObject, UICollectionViewDataSource {
    private var subDataSources: [SectionType: any SubDataSource] = [.banner: BannerDataSource(),
                                                                    .button: ButtonDataSource(),
                                                                    .bookInfo: BookInfoDataSource(),
                                                                    .starRate: StarRateDataSource(),
                                                                    .review: ReviewDataSource()]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionType(rawValue: section) else { return 0 }
        return subDataSources[section]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SectionType(rawValue: indexPath.section),
              let subDataSource = subDataSources[section] else { return UICollectionViewCell() }
        return subDataSource.dequeCell(from: collectionView, at: indexPath)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subDataSources.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = SectionType(rawValue: indexPath.section),
            let subDataSource = subDataSources[section] else { return UICollectionReusableView() }
        return subDataSource.reusableView(from: collectionView, kind: kind, at: indexPath)
    }
}

// MARK: - Configure

extension DetailDataSource {
    func sectionProvider(index: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        guard let section = SectionType(rawValue: index) else { return BannerDataSource().section }
        let subDataSource = subDataSources[section] ?? BannerDataSource()

        return subDataSource.section
    }

    func configure(at sectionType: SectionType, with viewModel: any SectionViewModel) {
        subDataSources[sectionType]?.configure(with: viewModel)
//        viewModels.enumerated().forEach { subDataSources[$0]?.configure(with: $1) }
    }
}
