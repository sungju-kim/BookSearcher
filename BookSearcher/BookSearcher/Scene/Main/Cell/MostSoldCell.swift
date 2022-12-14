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

    private var viewModel: MostSoldViewModel?

    static var identifier: String {
        return "\(self)"
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private let authorLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = Constraint.min

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

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension MostSoldCell {
    func layoutContainer() {
        addSubview(containerView)

        [imageView, titleLabel, authorLabel].forEach { containerView.addArrangedSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
