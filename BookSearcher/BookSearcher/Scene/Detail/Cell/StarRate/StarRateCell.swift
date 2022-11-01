//
//  StarRateCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class StarRateCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    private var viewModel: StarRateCellViewModel?

    static var identifier: String {
        return "\(self)"
    }

    private let ratingLabel: UILabel = {
        let label = CustomLabel(fontColor: .white, fontSize: 60, fontWeight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let starRateView = StarRateView()

    private let countLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray, fontSize: 12, fontWeight: .regular)
        label.textAlignment = .center
        return label
    }()

    private lazy var leftContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min
        stackView.distribution = .fill

        [ratingLabel, starRateView, countLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let rateCountView: RateCountView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutLeftContainer()
        layoutRateCountView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutLeftContainer()
        layoutRateCountView()
    }
}

// MARK: - Configure
extension StarRateCell {
    func configure(with viewModel: StarRateCellViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadRate
            .bind(to: ratingLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadRateCount
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadReviewRatio
            .bind(onNext: rateCountView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadStarRate
            .bind(onNext: starRateView.configure)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension StarRateCell {
    func layoutLeftContainer() {
        contentView.addSubview(leftContainer)

        leftContainer.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
    }

    func layoutRateCountView() {
        contentView.addSubview(rateCountView)

        rateCountView.snp.makeConstraints { make in
            make.leading.equalTo(leftContainer.snp.trailing).offset(Constraint.regular)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
