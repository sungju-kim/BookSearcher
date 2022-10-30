//
//  MostSoldViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/29.
//

import Foundation
import RxSwift
import RxRelay

final class MostSoldViewModel {
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadTitle = PublishRelay<String>()
        let didLoadAuthor = PublishRelay<String>()
        let didLoadImage = PublishRelay<Data>()
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
    }
}
