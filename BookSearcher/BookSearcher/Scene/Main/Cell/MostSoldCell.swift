//
//  MostSoldCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import RxSwift
import SnapKit

final class MostSoldCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    static var identifier: String {
        return "\(self)"
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
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
        stackView.distribution = .fillProportionally
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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - Configure

extension MostSoldCell {
    func configure(with viewModel: MostSoldViewModel) {
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

        viewModel.input.cellDidLoad.accept(())
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
