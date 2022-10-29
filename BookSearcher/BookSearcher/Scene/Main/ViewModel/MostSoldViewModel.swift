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
        let didLoadData = PublishRelay<Item>()
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
            .withUnretained(self)
            .flatMapLatest { viewModel, url in
                viewModel.repository.downLoadImage(url: url)}
            .bind(to: output.didLoadImage)
            .disposed(by: disposeBag)

        viewDidLoad
            .map { item }
            .bind(to: output.didLoadData)
            .disposed(by: disposeBag)
    }
}
