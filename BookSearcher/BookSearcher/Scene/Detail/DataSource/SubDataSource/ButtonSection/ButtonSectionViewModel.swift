//
//  ButtonSectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

final class ButtonSectionViewModel: SectionViewModel {
    var headerText: String?

    var cellViewModels: [ButtonCellViewModel]?

    init(headerText: String?, cellViewModels: [CellViewModel]) {
        guard let cellViewModels = cellViewModels as? [ButtonCellViewModel] else { return }
        self.cellViewModels = cellViewModels
    }
}
