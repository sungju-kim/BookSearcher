//
//  RangeView.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit
import SnapKit

final class RangeView: UIView {
    private let rateLabel: UILabel = {
        let label = CustomLabel(fontColor: .white, fontSize: 16, fontWeight: .bold)
        return label
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Custom.rateBackground
        return view
    }()

    private let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Custom.starRate
        return view
    }()

    override func draw(_ rect: CGRect) {
        foregroundView.layer.cornerRadius = foregroundView.frame.height / 2
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
    }

    convenience init(rate number: Int) {
        self.init()
        rateLabel.text = "\(number)"

        layoutRateLabel()
        layoutBackgroundView()
        layoutForegroundView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutRateLabel()
        layoutBackgroundView()
        layoutForegroundView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutRateLabel()
        layoutBackgroundView()
        layoutForegroundView()
    }
}

// MARK: - Configure

extension RangeView {
    func configure(rate: Double) {
        foregroundView.snp.remakeConstraints() { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(Constraint.regular)
            make.top.bottom.equalToSuperview().inset(Constraint.min / 1.5)
            make.width.equalTo(backgroundView).multipliedBy(rate)
        }
    }
}

// MARK: - Layout Section

private extension RangeView {
    func layoutRateLabel() {
        addSubview(rateLabel)

        rateLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(Constraint.min)
        }
    }

    func layoutForegroundView() {
        addSubview(foregroundView)

        foregroundView.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(Constraint.regular)
            make.top.bottom.equalToSuperview().inset(Constraint.min / 1.5)
            make.width.equalTo(0)
        }
    }

    func layoutBackgroundView() {
        addSubview(backgroundView)

        backgroundView.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(Constraint.regular)
            make.top.bottom.equalToSuperview().inset(Constraint.min / 1.5)
            make.trailing.equalToSuperview()
        }
    }
}
