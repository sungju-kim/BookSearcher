//
//  BannerSectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

final class BannerSectionViewModel: SectionViewModel {
    var headerText: String?

    var cellViewModels: [BannerCellViewModel]?

    init(headerText: String?, cellViewModels: [CellViewModel]) {
        self.headerText = headerText
        guard let cellViewModels = cellViewModels as? [BannerCellViewModel] else { return }
        self.cellViewModels = cellViewModels
    }
}
