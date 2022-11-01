//
//  RateCountView.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit
import SnapKit

final class RateCountView: UIView {
    private var rangeViews: [RangeView] = (1...5).map { RangeView(rate: $0) }

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min
        stackView.distribution = .fillEqually
        rangeViews.reversed().forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutContainer()
    }
}

// MARK: - Configure

extension RateCountView {
    func configure(rates: [Double]) {
        rates.enumerated().forEach { rangeViews[$0].configure(rate: $1) }
    }
}

// MARK: - Layout Section

private extension RateCountView {
    func layoutContainer() {
        addSubview(container)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
