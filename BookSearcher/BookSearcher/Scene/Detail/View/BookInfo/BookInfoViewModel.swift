//
//  BookInfoViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class BookInfoViewModel {
    private let disposeBag = DisposeBag()
    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadText = PublishRelay<String>()
    }

    let input = Input()
    let output = Output()

    func configure(with text: String) -> BookInfoViewModel {
        input.cellDidLoad
            .compactMap { text }
            .bind(to: output.didLoadText)
            .disposed(by: disposeBag)

        return self
    }
}
