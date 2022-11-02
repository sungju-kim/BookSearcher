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

final class RatingViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }

    struct Output {
        let isDataHidden = BehaviorRelay<Bool>(value: true)
        let didLoadRate = PublishRelay<String>()
        let didLoadStarRate = PublishRelay<Double>()
        let didLoadRateCount = PublishRelay<String>()
        let didLoadReviewRatio = PublishRelay<[Int: Double]>()
    }

    let input = Input()
    let output = Output()

    func configure(with ratingInfo: RatingInfo, and reviewList: [Review]) -> RatingViewModel {
        input.cellDidLoad
            .compactMap { ratingInfo.ratingScore }
            .map { round($0 * 5) / 10 }
            .map { String($0) }
            .bind(to: output.didLoadRate)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { ratingInfo.ratingScore }
            .map { $0/10 }
            .bind(to: output.didLoadStarRate)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { ratingInfo.ratingCount }
            .map { "평점 \($0)개"}
            .bind(to: output.didLoadRateCount)
            .disposed(by: disposeBag)

        input.cellDidLoad
            .compactMap { (ratingInfo.ratingCount, reviewList) }
            .map(getRatio)
            .bind(to: output.didLoadReviewRatio)
            .disposed(by: disposeBag)

        Observable.zip(output.didLoadRate.map { _ in },
                        output.didLoadRate.map { _ in },
                        output.didLoadStarRate.map { _ in },
                        output.didLoadRateCount.map { _ in },
                        output.didLoadReviewRatio.map { _ in })
        .map { _ in false }
        .bind(to: output.isDataHidden)
        .disposed(by: disposeBag)

        return self
    }

    private func getRatio(totalCount: Int?, reviews: [Review]?) -> [Int: Double] {
        guard let reviews = reviews,
              let totalCount = totalCount else { return [:] }

        var reviewCounter: [Int: Double] = [:]

        reviews.forEach { reviewCounter[$0.reviewRank / 2, default: 0] += 1 }

        var ratios: [Int: Double] = [:]
        reviewCounter.forEach { ratios[$0.key, default: 0] = $0.value / Double(totalCount) }

        ratios[1, default: 0] += ratios[0, default: 0]
        ratios[0] = nil
        return  ratios
    }
}
