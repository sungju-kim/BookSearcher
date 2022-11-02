//
//  DetailViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    private let disposebag = DisposeBag()
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadReview = PublishRelay<[ReviewCellViewModel]>()
        let openURL = PublishRelay<URL>()
        let didAddWishList = PublishRelay<Void>()
    }

    struct SubViewModels {
        let bannerViewModel = BannerViewModel()
        let buttonViewModel = ButtonViewModel()
        let bookInfoViewModel = BookInfoViewModel()
        let ratingViewModel = RatingViewModel()
    }

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()
    let subViewModels = SubViewModels()

    init(itemId: String) {
        let item = input.viewDidLoad
            .map { itemId }
            .flatMapLatest(repository.searchInformation)
            .compactMap { $0.item }
            .compactMap { $0.first }
            .share()

        item
            .bind(to: subViewModels.bannerViewModel.input.updateItem)
            .disposed(by: disposebag)

        item
            .compactMap { $0.subInfo }
            .bind(to: subViewModels.ratingViewModel.input.updateRating)
            .disposed(by: disposebag)

        item
            .compactMap { $0.mallType }
            .bind(to: subViewModels.bookInfoViewModel.input.updateHeader)
            .disposed(by: disposebag)

        item
            .compactMap { $0.itemDescription }
            .bind(to: subViewModels.bookInfoViewModel.input.updateText)
            .disposed(by: disposebag)
        item
            .compactMap { $0.subInfo }
            .map { $0.mockReviewList() }
            .map { $0.map { ReviewCellViewModel(review: $0) } }
            .bind(to: output.didLoadReview)
            .disposed(by: disposebag)

        subViewModels.buttonViewModel.input.wishListButtonTapped
                    .bind(to: output.didAddWishList)
                    .disposed(by: disposebag)

        subViewModels.buttonViewModel.input.linkButtonTapped
            .withLatestFrom(item)
            .compactMap { $0.link }
            .compactMap { URL(string: $0) }
            .bind(to: output.openURL)
            .disposed(by: disposebag)
    }
}
