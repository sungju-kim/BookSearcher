//
//  SearchViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/30.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let viewWillPresent = PublishRelay<Void>()
        let beforeButtonTapped = PublishRelay<Void>()
    }

    struct Output {
        let presentSearchView = PublishRelay<Void>()
        let dismissSearchView = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()

    init() {
        input.viewWillPresent
            .bind(to: output.presentSearchView)
            .disposed(by: disposeBag)

        input.beforeButtonTapped
            .bind(to: output.dismissSearchView)
            .disposed(by: disposeBag)

    }
}
