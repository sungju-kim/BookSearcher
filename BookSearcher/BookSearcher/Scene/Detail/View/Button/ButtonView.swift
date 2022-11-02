//
//  ButtonView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa

final class ButtonView: UIView {
    private let disposeBag = DisposeBag()

    private var viewModel: ButtonViewModel?

    private let readButton: UIButton = CustomButton(title: "자세히 보기",
                                                     backgroundColor: .clear,
                                                     fontColor: .Custom.buttonBlue)

    private let wishListButton: UIButton = CustomButton(title: "위시리스트에 추가",
                                                         image: UIImage(systemName: "bookmark.square"),
                                                         backgroundColor: .Custom.buttonBlue,
                                                         fontColor: .Custom.background)

    private let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constraint.min
        return stackView
    }()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutButtonContainer()
        layoutBorder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutButtonContainer()
        layoutBorder()
    }
}

// MARK: - Configure
extension ButtonView {
    func configure(with viewModel: ButtonViewModel) {
        self.viewModel = viewModel

        readButton.rx.tap
            .bind(to: viewModel.input.linkButtonTapped)
            .disposed(by: disposeBag)

        wishListButton.rx.tap
            .bind(to: viewModel.input.wishListButtonTapped)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Section

private extension ButtonView {
    func layoutButtonContainer() {
        addSubview(buttonContainer)

        [readButton, wishListButton].forEach { buttonContainer.addArrangedSubview($0) }

        buttonContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constraint.regular)
            make.leading.trailing.bottom.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutBorder() {
        addSubview(border)

        border.snp.makeConstraints { make in
            make.top.equalTo(buttonContainer.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
