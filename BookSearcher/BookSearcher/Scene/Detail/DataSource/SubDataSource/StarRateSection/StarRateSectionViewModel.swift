//
//  StarRateSectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

final class StarRateSectionViewModel: SectionViewModel {
    var headerText: String?
    
    var cellViewModels: [StarRateCellViewModel]?

    init(headerText: String?, cellViewModels: [CellViewModel]) {
        self.headerText = headerText
        guard let cellViewModels = cellViewModels as? [StarRateCellViewModel] else { return }
        self.cellViewModels = cellViewModels
    }
}
