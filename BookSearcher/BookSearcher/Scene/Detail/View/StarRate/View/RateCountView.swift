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

    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min / 2
        stackView.distribution = .fillEqually

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
    func configure(rates: [Int: Double]) {
        rates.forEach { rangeViews[$0 - 1].configure(rate: $1) }
    }
}

// MARK: - Layout Section

private extension RateCountView {
    func layoutContainer() {
        addSubview(container)

        rangeViews.reversed().forEach { container.addArrangedSubview($0) }

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
