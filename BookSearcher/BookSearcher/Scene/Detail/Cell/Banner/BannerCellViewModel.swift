//
//  BannerCellViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxRelay

final class BannerCellViewModel: CellViewModel {
    private let disposeBag = DisposeBag()
    struct Input {
        let cellDidLoad = PublishRelay<Void>()
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

    init(item: Item) {
        input.cellDidLoad
            .compactMap { item.imageURL }
            .flatMapLatest(repository.downLoadImage)
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.title}
            .bind(to: output.didLoadTitle)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.author }
            .bind(to: output.didLoadAuthor)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { item.mallType }
            .bind(to: output.didLoadInfo)
            .disposed(by: disposeBag)
    }
}
