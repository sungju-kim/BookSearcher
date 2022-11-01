//
//  BookInfoCellViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class BookInfoCellViewModel: CellViewModel {
    private let disposeBag = DisposeBag()
    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadText = PublishRelay<String>()
    }

    let input = Input()
    let output = Output()

    init(text: String) {
        input.cellDidLoad
            .compactMap { text }
            .bind(to: output.didLoadText)
            .disposed(by: disposeBag)
    }
}
