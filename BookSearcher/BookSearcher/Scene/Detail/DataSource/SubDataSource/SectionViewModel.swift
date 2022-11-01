//
//  SectionViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation

protocol SectionViewModel {
    associatedtype CellViewModelType
    var headerText: String? { get }
    var cellViewModels: [CellViewModelType]? { get }

    init(headerText: String?, cellViewModels: [CellViewModel])
}
