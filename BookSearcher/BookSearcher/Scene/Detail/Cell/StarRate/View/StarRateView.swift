//
//  StarRateView.swift
//  BookSearcher
//
//  Created by dale on 2022/11/01.
//

import UIKit
import SnapKit

final class StarRateView: UIView {
    private lazy var visibleView: UIView = {
        let view = UIView()
        view.backgroundColor = .Custom.starRate
        return view
    }()

    private lazy var backgroundView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        (0...4).forEach { _ in
            let image = UIImage(systemName: "star")
            var imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .Custom.starRate
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()

    private lazy var foregroundView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        (0...4).forEach { _ in
            let image = UIImage(systemName: "star.fill")
            var imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()

    override func draw(_ rect: CGRect) {
        visibleView.mask = foregroundView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutVisibleView()
        layoutBackgroundView()
        layoutForegroundView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutVisibleView()
        layoutBackgroundView()
        layoutForegroundView()
    }
}

// MARK: - Configure

extension StarRateView {
    func configure(rate: Double) {
        visibleView.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(backgroundView).multipliedBy(rate)
            make.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Layout Section

private extension StarRateView {
    func layoutVisibleView() {
        addSubview(visibleView)

        visibleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(0)
            make.top.bottom.equalToSuperview()
        }
    }

    func layoutForegroundView() {
        addSubview(foregroundView)

        foregroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func layoutBackgroundView() {
        addSubview(backgroundView)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
