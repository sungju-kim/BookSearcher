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
        let isDataHidden = BehaviorRelay<Bool>(value: true)
        let didLoadText = PublishRelay<String>()
    }

    let input = Input()
    let output = Output()

    func configure(with text: String) -> BookInfoViewModel {
        let validText = input.cellDidLoad
            .compactMap { text }
            .share()

        validText
            .bind(to: output.didLoadText)
            .disposed(by: disposeBag)

        validText
            .map { $0 == "" }
            .bind(to: output.isDataHidden)
            .disposed(by: disposeBag)

        return self
    }
}
