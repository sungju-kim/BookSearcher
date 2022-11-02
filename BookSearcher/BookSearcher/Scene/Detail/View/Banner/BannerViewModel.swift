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
        let viewDidLoad = PublishRelay<Void>()
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

    func configure(with item: Item) -> BannerViewModel {
        input.viewDidLoad
            .compactMap { item.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        input.viewDidLoad
            .compactMap { item.title}
            .bind(to: output.didLoadTitle)
            .disposed(by: disposeBag)

        input.viewDidLoad
            .compactMap { item.author }
            .bind(to: output.didLoadAuthor)
            .disposed(by: disposeBag)

        input.viewDidLoad
            .compactMap { item.mallType }
            .bind(to: output.didLoadInfo)
            .disposed(by: disposeBag)

        return self
    }
}
