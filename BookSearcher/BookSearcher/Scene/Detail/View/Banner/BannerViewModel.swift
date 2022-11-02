//
//  BannerViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxRelay

final class BannerViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let updateItem = PublishRelay<Item>()
    }

    struct Output {
        let didLoadImage = PublishRelay<Data>()
        let didLoadTitle = PublishRelay<String>()
        let didLoadAuthor = PublishRelay<String>()
        let didLoadInfo = PublishRelay<String>()
    }

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init() {
        input.updateItem
            .compactMap { $0.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        input.updateItem
            .compactMap { $0.title }
            .bind(to: output.didLoadTitle)
            .disposed(by: disposeBag)

        input.updateItem
            .compactMap { $0.author }
            .bind(to: output.didLoadAuthor)
            .disposed(by: disposeBag)

        input.updateItem
            .compactMap { $0.mallType }
            .bind(to: output.didLoadInfo)
            .disposed(by: disposeBag)
    }
}
