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

    private let headerLabel: UILabel = {
        let label = CustomLabel(fontColor: .white, fontSize: 28, fontWeight: .semibold)
        label.text = "Book 정보"
        return label
    }()

    private let textLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isHidden = true
        layoutHeaderLabel()
        layoutTextLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.isHidden = true
        layoutHeaderLabel()
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

        viewModel.output.isDataHidden
            .bind(to: self.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.input.cellDidLoad.accept(())
    }
}

// MARK: - Layout Section

private extension BookInfoView {
    func layoutHeaderLabel() {
        addSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraint.regular)
            make.top.equalToSuperview().inset(Constraint.semiMax)
        }
    }

    func layoutTextLabel() {
        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.bottom.equalToSuperview().inset(Constraint.regular)
        }
    }
}
