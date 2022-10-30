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
        let viewDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadTitle = PublishRelay<String>()
        let didLoadAuthor = PublishRelay<String>()
        let didLoadImage = PublishRelay<Data>()
        let didLoadType = PublishRelay<String>()
        let didLoadRate = PublishRelay<String>()
    }
    private let disposeBag = DisposeBag()

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init(item: Item) {
        let viewDidLoad = input.viewDidLoad.share()

        viewDidLoad
            .compactMap { item.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        viewDidLoad
            .compactMap { item.title }
            .bind(to: output.didLoadTitle)
            .disposed(by: disposeBag)

        viewDidLoad
            .compactMap { item.author }
            .bind(to: output.didLoadAuthor)
            .disposed(by: disposeBag)

        viewDidLoad
            .compactMap { item.mallType }
            .bind(to: output.didLoadType)
            .disposed(by: disposeBag)

        // MARK: TODO - 별점 정보 파싱 필요
        viewDidLoad
            .compactMap { item.customerReviewRank }
            .compactMap { String($0) }
            .bind(to: output.didLoadRate)
            .disposed(by: disposeBag)
    }
}
