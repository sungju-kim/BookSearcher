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
        let selectedIndex = BehaviorRelay<Int>(value: 0)
        let itemSelected = PublishRelay<IndexPath>()
    }

    struct Output {
        let loadedData = PublishRelay<[SearchResultViewModel]>()
        let presentSearchView = PublishRelay<Void>()
        let dismissSearchView = PublishRelay<Void>()
        let prepareForPush = PublishRelay<DetailViewModel>()
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

        let items = Observable.combineLatest(input.searchButtonClicked, input.selectedIndex.compactMap { ItemType(rawValue: $0) })
            .map { ($0, 0, $1) }
            .flatMapLatest(repository.searchItem)
            .compactMap { $0.item }
            .share()

        items
            .map { $0.map { SearchResultViewModel(item: $0) } }
            .bind(to: output.loadedData)
            .disposed(by: disposeBag)

        input.itemSelected
            .withLatestFrom(items) { ($0, $1) }
            .map { indexPath, items in
                items[indexPath.item] }
            .compactMap { $0.isbn13 }
            .map { DetailViewModel(itemId: $0) }
            .bind(to: output.prepareForPush)
            .disposed(by: disposeBag)
    }
}
