//
//  ReviewCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ReviewCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    private var viewModel: ReviewCellViewModel?

    static var identifier: String {
        return "\(self)"
    }

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .Custom.textGray
        imageView.clipsToBounds = true
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
        stackView.spacing = Constraint.min

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        layoutImageView()
        layoutContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = .clear
        selectionStyle = .none
        layoutImageView()
        layoutContainer()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}

// MARK: - Configure
extension ReviewCell {
    func configure(with viewModel: ReviewCellViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadImage
            .compactMap { UIImage(data: $0) }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.didLoadName
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadDate
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.didLoadStarRate
            .bind(onNext: starRateView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadContent
            .bind(to: reviewConent.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension ReviewCell {
    func layoutImageView() {
        contentView.addSubview(userImageView)

        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.leading.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutContainer() {
        contentView.addSubview(container)

        container.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(Constraint.regular)
            make.top.bottom.trailing.equalToSuperview().inset(Constraint.regular)
        }
    }
}
