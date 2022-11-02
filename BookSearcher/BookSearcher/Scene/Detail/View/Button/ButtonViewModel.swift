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
        let wishListButtonTapped = PublishRelay<Void>()
    }

    let input = Input()
}
