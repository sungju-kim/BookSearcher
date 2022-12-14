//
//  UnderLineView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import SnapKit

final class UnderLineView: UIView {
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill

        return stackView
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .Custom.selectedItem
        return view
    }()

    private let leadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutContainerView()
        layoutLabels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutContainerView()
        layoutLabels()
    }
}

// MARK: - Layout Section

private extension UnderLineView {
    func layoutContainerView() {
        addSubview(containerView)

        [leadingView, lineView, trailingView].forEach { containerView.addArrangedSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func layoutLabels() {
        lineView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview()
        }

        leadingView.snp.makeConstraints { make in
            make.width.equalTo(lineView).multipliedBy(2)
            make.height.equalToSuperview()
        }

        trailingView.snp.makeConstraints { make in
            make.width.equalTo(lineView).multipliedBy(2)
            make.height.equalToSuperview()
        }
    }
}
