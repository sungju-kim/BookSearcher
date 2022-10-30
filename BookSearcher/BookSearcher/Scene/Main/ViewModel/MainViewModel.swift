//
//  MainViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let selectedIndex = BehaviorRelay<Int>(value: 0)
        let searchButtonTapped = PublishRelay<Void>()
    }

    struct Output {
        let loadedData = PublishRelay<[MostSoldViewModel]>()
        let selectedMenu = BehaviorRelay<ItemType>(value: .eBook)
        let didLoadSearchViewModel = PublishRelay<SearchViewModel>()
        let showSearchView = PublishRelay<Void>()
        let dismissSearchView = PublishRelay<Void>()
    }
    private let disposeBag = DisposeBag()

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init() {
        input.selectedIndex
            .compactMap { ItemType(rawValue: $0) }
            .bind(to: output.selectedMenu)
            .disposed(by: disposeBag)

        Observable.combineLatest(input.viewDidLoad.asObservable(), output.selectedMenu.asObservable()) { $1 }
            .withUnretained(self)
            .flatMapLatest { $0.repository.searchBestSeller(itemType: $1) }
            .compactMap { $0.item }
            .map { $0.map { MostSoldViewModel(item: $0) } }
            .bind(to: output.loadedData)
            .disposed(by: disposeBag)

        let searchViewModel = SearchViewModel()

        input.viewDidLoad
            .map { searchViewModel }
            .bind(to: output.didLoadSearchViewModel)
            .disposed(by: disposeBag)

        input.searchButtonTapped
            .bind(to: searchViewModel.input.viewWillPresent)
            .disposed(by: disposeBag)

        input.searchButtonTapped
            .bind(to: output.showSearchView)
            .disposed(by: disposeBag)

        searchViewModel.output.dismissSearchView
            .bind(to: output.dismissSearchView)
            .disposed(by: disposeBag)
    }
}
