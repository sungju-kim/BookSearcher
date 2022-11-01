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
        let didLoadData = PublishRelay<[any SectionViewModel]>()
    }

    @Injector(keypath: \.repository)
    private var repository: Repository

    let input = Input()
    let output = Output()

    init(itemId: String) {
        let loadedData = input.viewDidLoad
            .map { itemId }
            .flatMapLatest(repository.searchInformation)
            .compactMap { $0.item }
            .compactMap { $0.first }
            .share()

        let bannerSectionViewModel = loadedData
            .map { BannerSectionViewModel(headerText: nil, cellViewModels: [BannerCellViewModel(item: $0)]) }
                .share()

        let buttonSectionViewModel = loadedData
            .map { $0.link }
            .map { [ButtonCellViewModel(link: $0)] }
            .map { ButtonSectionViewModel(headerText: nil, cellViewModels: $0)}
            .share()

        let bookInfoSectionViewModel = loadedData
            .map { $0.itemDescription }
            .map { [BookInfoCellViewModel(text: $0)] }
            .map { BookInfoSectionViewModel(headerText: "eBook 정보", cellViewModels: $0)}
            .share()

        let starRateSectionViewModel = loadedData
            .map { ($0.subInfo?.ratingInfo, $0.subInfo?.reviewList)}
            .map {[StarRateCellViewModel(ratingInfo: $0.0, reviewList: $0.1)]}
            .map { StarRateSectionViewModel(headerText: "평점 및 리뷰", cellViewModels: $0)}
            .share()

        let reviewSectionViewModel = loadedData
            .map { $0.subInfo?.reviewList ?? [] }
            .map { $0.map { ReviewCellViewModel(review: $0) }}
            .map { ReviewSectionViewModel(headerText: "평점 및 리뷰 정보", cellViewModels: $0)}
            .share()

        Observable.zip(bannerSectionViewModel, buttonSectionViewModel, bookInfoSectionViewModel, starRateSectionViewModel, reviewSectionViewModel)
            .map {  [$0, $1, $2, $3, $4] }
            .bind(to: output.didLoadData)
            .disposed(by: disposebag)
    }
}
