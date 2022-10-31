//
//  BookInformationView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import SnapKit

final class BookInformationView: UIView {
    private(set) var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        return imageView
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = CustomLabel(fontColor: .white,
                                fontSize: 28,
                                fontWeight: .semibold)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.text = "타이틀 입니다."
        return label
    }()

    private(set) var authorLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 14,
                                fontWeight: .regular)
        label.numberOfLines = 1
        label.text = "작가 입니다."
        return label
    }()

    private(set) var informationLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 14,
                                fontWeight: .regular)
        label.text = "EBOOK ' 240page"
        return label
    }()

    private lazy var labelContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min
        [titleLabel, authorLabel, informationLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutImageView()
        layoutLabelContainer()
        layoutBorder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutImageView()
        layoutLabelContainer()
        layoutBorder()
    }
}

// MARK: - Layout Section

private extension BookInformationView {
    func layoutImageView() {
        addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(180)
            make.top.leading.bottom.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutLabelContainer() {
        addSubview(labelContainer)

        labelContainer.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constraint.regular)
            make.leading.equalTo(imageView.snp.trailing).offset(Constraint.regular)
        }
    }

    func layoutBorder() {
        addSubview(border)

        border.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
