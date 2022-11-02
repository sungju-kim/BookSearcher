//
//  BookInfoView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa

final class BookInfoView: UIView {
    private var disposeBag = DisposeBag()

    private var viewModel: BookInfoViewModel?

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
}

// MARK: - Configure
extension BookInfoView {
    func configure(with viewModel: BookInfoViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadText
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension BookInfoView {
    func layoutTextLabel() {
        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constraint.regular)
        }
    }
}
