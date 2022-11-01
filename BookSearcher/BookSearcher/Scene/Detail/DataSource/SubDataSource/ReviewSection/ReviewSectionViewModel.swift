//
//  ReviewSectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

final class ReviewSectionViewModel: SectionViewModel {
    var headerText: String?

    var cellViewModels: [ReviewCellViewModel]?

    init(headerText: String?, cellViewModels: [CellViewModel]) {
        self.headerText = headerText
        guard let cellViewModels = cellViewModels as? [ReviewCellViewModel] else { return }
        self.cellViewModels = cellViewModels
    }
}
