//
//  SearchResultViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/30.
//

import Foundation
import RxSwift
import RxRelay

final class SearchResultViewModel {
    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadTitle = PublishRelay<String>()
        let didLoadAuthor = PublishRelay<String>()
        let didLoadImage = PublishRelay<Data>()
        let didLoadType = PublishRelay<String>()
        let didLoadRate = PublishRelay<String>()
        let starLabelIsHidden = PublishRelay<Bool>()
    }
    private let disposeBag = DisposeBag()

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init(item: Item) {
        input.cellDidLoad
            .compactMap { item.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.title }
            .bind(to: output.didLoadTitle)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.author }
            .bind(to: output.didLoadAuthor)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.mallType }
            .bind(to: output.didLoadType)
            .disposed(by: disposeBag)

        let rate = input.cellDidLoad
            .compactMap { item.customerReviewRank }
            .compactMap { Double($0) / 2 }
            .share()

        rate
            .filter { $0 != 0 }
            .compactMap { String($0) }
            .bind(to: output.didLoadRate)
            .disposed(by: disposeBag)

        rate
            .map { $0 == 0 }
            .bind(to: output.starLabelIsHidden)
            .disposed(by: disposeBag)

    }
}
