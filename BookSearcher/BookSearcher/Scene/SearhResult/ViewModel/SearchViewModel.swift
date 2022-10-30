//
//  SearchViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/30.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let viewWillPresent = PublishRelay<Void>()
        let beforeButtonTapped = PublishRelay<Void>()
        let searchButtonClicked = PublishRelay<String>()
    }

    struct Output {
        let loadedData = PublishRelay<[SearchResultViewModel]>()
        let presentSearchView = PublishRelay<Void>()
        let dismissSearchView = PublishRelay<Void>()
    }

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init() {
        input.viewWillPresent
            .bind(to: output.presentSearchView)
            .disposed(by: disposeBag)

        input.beforeButtonTapped
            .bind(to: output.dismissSearchView)
            .disposed(by: disposeBag)

        input.searchButtonClicked
            .map { ($0, 0, ItemType.eBook )}
            .flatMapLatest(repository.searchItem)
            .compactMap { $0.item }
            .map { $0.map { SearchResultViewModel(item: $0) } }
            .bind(to: output.loadedData)
            .disposed(by: disposeBag)
    }
}
