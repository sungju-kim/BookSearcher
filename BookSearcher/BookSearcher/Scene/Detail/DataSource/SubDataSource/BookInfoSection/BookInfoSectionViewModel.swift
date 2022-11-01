//
//  BookInfoSectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

final class BookInfoSectionViewModel: SectionViewModel {
    var headerText: String?

    var cellViewModels: [BookInfoCellViewModel]?

    init(headerText: String?, cellViewModels: [CellViewModel]) {
        self.headerText = headerText
        guard let cellViewModels = cellViewModels as? [BookInfoCellViewModel] else { return }
        self.cellViewModels = cellViewModels
    }
}
