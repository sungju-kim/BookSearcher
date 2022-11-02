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
        let didLoadBannerViewModel = PublishRelay<BannerViewModel>()
        let didLoadButtonViewModel = PublishRelay<ButtonViewModel>()
        let didLoadBookInfoViewModel = PublishRelay<BookInfoViewModel>()
        let didLoadRatingViewModel = PublishRelay<RatingViewModel>()
        let didLoadReview = PublishRelay<[ReviewCellViewModel]>()

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
    private let subViewModels = SubViewModels()

    init(itemId: String) {
        let item = input.viewDidLoad
            .map { itemId }
            .flatMapLatest(repository.searchInformation)
            .compactMap { $0.item }
            .compactMap { $0.first }
            .share()

        item
            .withUnretained(self)
            .map { ($0.subViewModels.bannerViewModel, $1) }
            .map { $0.configure(with: $1) }
            .bind(to: output.didLoadBannerViewModel)
            .disposed(by: disposebag)

        item
            .compactMap { $0.link }
            .withUnretained(self)
            .map { ($0.subViewModels.buttonViewModel, $1) }
            .map { $0.configure(with: $1) }
            .bind(to: output.didLoadButtonViewModel)
            .disposed(by: disposebag)

        item
            .compactMap { $0.itemDescription }
            .withUnretained(self)
            .map { ($0.subViewModels.bookInfoViewModel, $1) }
            .map { $0.configure(with: $1) }
            .bind(to: output.didLoadBookInfoViewModel)
            .disposed(by: disposebag)
        let subInfo = item
            .compactMap { $0.subInfo }
            .share()

        Observable.zip( subInfo.compactMap { $0.ratingInfo }, subInfo.map { $0.mockReviewList() })
            .withUnretained(self)
            .map { ($0.subViewModels.ratingViewModel, $1.0, $1.1) }
            .map { $0.configure(with: $1, and: $2)}
            .bind(to: output.didLoadRatingViewModel)
            .disposed(by: disposebag)

        subInfo
            .map { $0.mockReviewList() }
            .map { $0.map { ReviewCellViewModel(review: $0) } }
            .bind(to: output.didLoadReview)
            .disposed(by: disposebag)

        bindSubViewModel()
    }
}

// MARK: - Bind

private extension DetailViewModel {
    func bindSubViewModel() {
        subViewModels.buttonViewModel.input.wishListButtonTapped
            .bind(to: output.didAddWishList)
            .disposed(by: disposebag)
    }
}
