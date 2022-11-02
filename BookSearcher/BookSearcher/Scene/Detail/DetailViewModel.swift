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
        let didLoadData = PublishRelay<(SectionType, any SectionViewModel)>()
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
            .map { (SectionType.banner, $0 as any SectionViewModel) }
                .share()

        let buttonSectionViewModel = loadedData
            .compactMap { $0.link }
            .map { [ButtonCellViewModel(link: $0)] }
            .map { ButtonSectionViewModel(headerText: nil, cellViewModels: $0) }
            .map { (SectionType.button, $0 as any SectionViewModel) }
            .share()

        let bookInfoSectionViewModel = loadedData
            .map { [$0.mallType, $0.itemDescription] }
            .compactMap { $0 as? [String] }
            .filter { $0[1] != ""}
            .map {
                BookInfoSectionViewModel(headerText: "\($0[0]) 정보",
                                         cellViewModels: [BookInfoCellViewModel(text: $0[1])]) }
            .map { (SectionType.bookInfo, $0 as any SectionViewModel) }
            .share()

        let subInfo = loadedData
            .compactMap { $0.subInfo }
            .share()

        let starRateSectionViewModel = Observable.zip( subInfo.compactMap { $0.ratingInfo }, subInfo.map { $0.mockReviewList() })
            .map { [StarRateCellViewModel(ratingInfo: $0, reviewList: $1)] }
            .map { StarRateSectionViewModel(headerText: "평점 및 리뷰", cellViewModels: $0) }
            .map { (SectionType.starRate, $0 as any SectionViewModel) }
            .share()

        let reviewSectionViewModel = subInfo
            .map { $0.mockReviewList() }
            .filter { !$0.isEmpty }
            .map { $0.map { ReviewCellViewModel(review: $0) } }
            .map { ReviewSectionViewModel(headerText: "평점 및 리뷰 정보", cellViewModels: $0) }
            .map { (SectionType.review, $0 as any SectionViewModel) }
            .share()

        Observable.merge(bannerSectionViewModel, buttonSectionViewModel, bookInfoSectionViewModel, starRateSectionViewModel, reviewSectionViewModel)
            .bind(to: output.didLoadData)
            .disposed(by: disposebag)
    }
}
