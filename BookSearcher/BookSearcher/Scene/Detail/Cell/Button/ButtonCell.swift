//
//  ButtonCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class ButtonCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }

    private let readButton: UIButton = CustomButton(title: "샘플 읽기",
                                                     backgroundColor: .clear,
                                                     fontColor: .Custom.buttonBlue)

    private let wishListButton: UIButton = CustomButton(title: "위시리스트에 추가",
                                                         image: UIImage(systemName: "bookmark.square"),
                                                         backgroundColor: .Custom.buttonBlue,
                                                         fontColor: .Custom.background)

    private lazy var buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constraint.min
        [readButton, wishListButton].forEach { stackView.addArrangedSubview($0) }
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
extension ButtonCell {
    func configure(with viewModel: ButtonCellViewModel) {
        
    }
}

// MARK: - Layout Section

private extension ButtonCell {
    func layoutButtonContainer() {
        contentView.addSubview(buttonContainer)

        buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutBorder() {
        contentView.addSubview(border)

        border.snp.makeConstraints { make in
            make.top.equalTo(buttonContainer.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
