//
//  SearchResultCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/30.
//

import UIKit
import RxSwift
import SnapKit

final class SearchResultCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }

    private var disposeBag = DisposeBag()

    private var viewModel: SearchResultCell?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = CustomLabel(fontColor: .white,
                                fontSize: 14,
                                fontWeight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let authorLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 2
        return label
    }()

    private let typeLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let rateLabel: UILabel = {
        var label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.init(750), for: .horizontal)
        return label
    }()

    private let starLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.text = "★"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var labelContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constraint.min
        stackView.distribution = .equalSpacing
        [titleLabel, authorLabel, informationContainer].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var informationContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constraint.min
        stackView.distribution = .fill
        [typeLabel, rateLabel, starLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        layoutCoverImage()
        layoutLabelContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = .clear

        layoutCoverImage()
        layoutLabelContainer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
        rateLabel.text = ""
        starLabel.isHidden = true
    }
}

// MARK: - Configure

extension SearchResultCell {
    func configure(with viewModel: SearchResultViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadImage
            .map { UIImage(data: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.didLoadTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadAuthor
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadType
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadRate
            .bind(to: rateLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.starLabelIsHidden
            .bind(to: starLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension SearchResultCell {
    func layoutCoverImage() {
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
    }

    func layoutLabelContainer() {
        contentView.addSubview(labelContainer)

        labelContainer.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Constraint.regular)
            make.top.trailing.equalToSuperview()
        }
    }
}
