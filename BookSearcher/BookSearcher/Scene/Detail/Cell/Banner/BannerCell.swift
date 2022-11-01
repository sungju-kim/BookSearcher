//
//  BannerCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa

final class BannerCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    private var viewModel: BannerCellViewModel?

    static var identifier: String {
        return "\(self)"
    }
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

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}

// MARK: - Configure

extension BannerCell {
    func configure(with viewModel: BannerCellViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadImage
            .compactMap { UIImage(data: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.didLoadTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadAuthor
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadInfo
            .bind(to: informationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension BannerCell {
    func layoutImageView() {
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.greaterThanOrEqualTo(180)
            make.top.leading.equalToSuperview().inset(Constraint.regular)
            make.bottom.equalToSuperview().inset(Constraint.semiMax)
        }
    }

    func layoutLabelContainer() {
        contentView.addSubview(labelContainer)

        labelContainer.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constraint.regular)
            make.leading.equalTo(imageView.snp.trailing).offset(Constraint.regular)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func layoutBorder() {
        contentView.addSubview(border)

        border.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
