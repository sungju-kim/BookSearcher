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
    private let disposeBag = DisposeBag()

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

// MARK: - Configure

extension MostSoldCell {
    func configure(with viewModel: MostSoldViewModel) {
        viewModel.output.didLoadImage
            .map { UIImage(data: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.didLoadData
            .withUnretained(self)
            .bind { cell, item in
                cell.titleLabel.text = item.title
                cell.authorLabel.text = item.author }
            .disposed(by: disposeBag)

        viewModel.input.viewDidLoad.accept(())
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
