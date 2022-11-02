//
//  ButtonViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ButtonViewModel {
    private let disposeBag = DisposeBag()
    struct Input {
        let linkButtonTapped = PublishRelay<Void>()
    }

    struct Output {
        let prepareForPresent = PublishRelay<URL>()
    }

    let input = Input()
    let output = Output()

    func configure(with link: String) -> ButtonViewModel {
        input.linkButtonTapped
            .compactMap { link }
            .compactMap { URL(string: $0) }
            .bind(to: output.prepareForPresent)
            .disposed(by: disposeBag)

        return self
    }
}
