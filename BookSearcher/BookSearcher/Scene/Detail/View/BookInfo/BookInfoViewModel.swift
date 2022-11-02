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
        let updateHeader = PublishRelay<String>()
        let updateText = PublishRelay<String>()
    }

    struct Output {
        let isDataHidden = BehaviorRelay<Bool>(value: true)
        let didLoadHeader = PublishRelay<String>()
        let didLoadText = PublishRelay<String>()
    }

    let input = Input()
    let output = Output()

    init() {
        input.updateText
            .bind(to: output.didLoadText)
            .disposed(by: disposeBag)

        input.updateText
            .map { $0.isEmpty }
            .bind(to: output.isDataHidden)
            .disposed(by: disposeBag)

        input.updateHeader
            .map { "\($0) 정보" }
            .bind(to: output.didLoadHeader)
            .disposed(by: disposeBag)
    }
}
