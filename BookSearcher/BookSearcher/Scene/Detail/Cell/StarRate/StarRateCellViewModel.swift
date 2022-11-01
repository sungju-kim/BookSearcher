//
//  StarRateCellViewModel.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class StarRateCellViewModel: CellViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let didLoadRate = PublishRelay<String>()
        let didLoadStarRate = PublishRelay<Double>()
        let didLoadRateCount = PublishRelay<String>()
        let didLoadReviewRatio = PublishRelay<[Double]>()
    }

    let input = Input()
    let output = Output()

    init(ratingInfo: RatingInfo?, reviewList: [Review]?) {
        input.cellDidLoad
            .compactMap { ratingInfo?.ratingScore }
            .map { round($0 * 5) / 10 }
            .map { String($0) }
            .bind(to: output.didLoadRate)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { ratingInfo?.ratingScore }
            .map { $0/10 }
            .bind(to: output.didLoadStarRate)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { ratingInfo?.ratingCount }
            .map { "평점 \($0)개"}
            .bind(to: output.didLoadRateCount)
            .disposed(by: disposeBag)

            // Mock ReviewList
        guard let count = ratingInfo?.ratingCount else { return }
        let reviewList: [Review] = (0..<count).map {Review(reviewRank: Int.random(in: 0...10), writer: "\($0)writer", link: "\($0)link", title: "\($0)title")}

        input.cellDidLoad
            .compactMap { (ratingInfo?.ratingCount, reviewList) }
            .map(getRatio)
            .bind(to: output.didLoadReviewRatio)
            .disposed(by: disposeBag)

    }

    private func getRatio(totalCount: Int?, reviews: [Review]?) -> [Double] {
        guard let reviews = reviews,
              let totalCount = totalCount else { return [] }

        var reviewCounter: [Int: Double] = [:]

        reviews.forEach { reviewCounter[$0.reviewRank / 2, default: 0] += 1 }

        // MARK: - TODO: 리뷰갯수가 다를때 (0점대가 없거나 1점대가 없거나) 에러 핸들링
        var ratios = reviewCounter.sorted { $0.key > $1.key }.map { $0.value / Double(totalCount) }

        ratios[1] += ratios[0]
        ratios.removeFirst()

        return  ratios
    }
}
