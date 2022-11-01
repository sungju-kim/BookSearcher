//
//  ReviewCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import SnapKit

final class ReviewCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = CustomLabel(fontColor: .white, fontSize: 14, fontWeight: .semibold)
        return label
    }()

    private let starRateView = StarRateView()

    private let dateLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray, fontSize: 14, fontWeight: .regular)
        return label
    }()

    private lazy var dateContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constraint.min / 2

        [starRateView, dateLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let reviewConent: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray, fontSize: 14, fontWeight: .regular)
        label.numberOfLines = 3
        return label
    }()

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min

        [nameLabel, dateContainer, reviewConent].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        imageView.layer.cornerRadius = imageView.frame.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutImageView()
        layoutContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutImageView()
        layoutContainer()
    }
}

// MARK: - Configure
extension ReviewCell {
    func configure(with viewModel: ReviewCellViewModel) {

    }
}

// MARK: - Layout Section

private extension ReviewCell {
    func layoutImageView() {
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.leading.equalToSuperview()
        }
    }

    func layoutContainer() {
        contentView.addSubview(container)

        container.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Constraint.regular)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
