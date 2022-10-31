//
//  DetailViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class DetailViewController: UIViewController {

    private let contentsView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let bookInformationView: BookInformationView = BookInformationView()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutContentView()
        layoutBookInformationView()
        layoutButtonContainer()
        layoutBorder()
    }
}

// MARK: - Layout Section

private extension DetailViewController {
    func layoutContentView() {
        view.addSubview(contentsView)

        contentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func layoutBookInformationView() {
        contentsView.addSubview(bookInformationView)

        bookInformationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func layoutButtonContainer() {
        contentsView.addSubview(buttonContainer)

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(bookInformationView.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constraint.regular)
        }
    }

    func layoutBorder() {
        contentsView.addSubview(border)

        border.snp.makeConstraints { make in
            make.top.equalTo(buttonContainer.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
}
