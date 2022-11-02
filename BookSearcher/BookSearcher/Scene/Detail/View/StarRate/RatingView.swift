//
//  RatingView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RatingView: UIView {
    private let disposeBag = DisposeBag()

    private var viewModel: RatingViewModel?

    private let headerLabel: UILabel = {
        let label = CustomLabel(fontColor: .white, fontSize: 28, fontWeight: .semibold)
        label.text = "평점 및 리뷰정보"
        return label
    }()

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

        self.isHidden = true
        layoutHeaderLabel()
        layoutLeftContainer()
        layoutRateCountView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.isHidden = true
        layoutHeaderLabel()
        layoutLeftContainer()
        layoutRateCountView()
    }
}

// MARK: - Configure
extension RatingView {
    func configure(with viewModel: RatingViewModel) {
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

        viewModel.output.isDataHidden
            .bind(to: self.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension RatingView {
    func layoutHeaderLabel() {
        addSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraint.regular)
            make.top.equalToSuperview().inset(Constraint.semiMax)
        }
    }

    func layoutLeftContainer() {
        addSubview(leftContainer)

        leftContainer.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Constraint.regular)
            make.leading.bottom.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutRateCountView() {
        addSubview(rateCountView)

        rateCountView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Constraint.regular)
            make.leading.equalTo(leftContainer.snp.trailing).offset(Constraint.regular)
            make.bottom.trailing.equalToSuperview().inset(Constraint.regular)
        }
    }
}
