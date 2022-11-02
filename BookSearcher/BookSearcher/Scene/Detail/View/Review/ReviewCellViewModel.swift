//
//  ReviewCellViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class ReviewCellViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadImage = PublishRelay<Data>()
        let didLoadName = PublishRelay<String>()
        let didLoadStarRate = PublishRelay<Double>()
        let didLoadDate = PublishRelay<String>()
        let didLoadContent = PublishRelay<String>()
    }

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init(review: Review) {
        input.cellDidLoad
            .compactMap { review.writer }
            .bind(to: output.didLoadName)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { review.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { review.reviewRank }
            .compactMap { Double($0) }
            .map { $0 / 10 }
            .bind(to: output.didLoadStarRate)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { review.title }
            .bind(to: output.didLoadContent)
            .disposed(by: disposeBag)
    }
}
