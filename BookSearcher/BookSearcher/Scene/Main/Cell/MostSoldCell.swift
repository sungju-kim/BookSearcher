//
//  MostSoldCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import SnapKit

final class MostSoldCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .Custom.textGray
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .Custom.textGray
        return label
    }()

    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Constraint.min

        [imageView, titleLabel, authorLabel].forEach { stackView.addArrangedSubview($0) }
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

// MARK: - Layout Section

private extension MostSoldCell {
    func layoutContainer() {
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
