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
    }

    struct Output {
        let loadedData = PublishRelay<[MostSoldViewModel]>()
        let selectedMenu = BehaviorRelay<ItemType>(value: .eBook)
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
    }
}
