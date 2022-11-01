//
//  BookInfoCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa

final class BookInfoCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    private var viewModel: BookInfoCellViewModel?

    static var identifier: String {
        return "\(self)"
    }

    private let textLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutTextLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutTextLabel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}

// MARK: - Configure
extension BookInfoCell {
    func configure(with viewModel: BookInfoCellViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadText
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension BookInfoCell {
    func layoutTextLabel() {
        contentView.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
