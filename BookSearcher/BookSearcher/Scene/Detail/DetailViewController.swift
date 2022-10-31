//
//  DetailViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxAppState

final class DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let contentsView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let navigationView = CustomNavigationView()

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

        view.backgroundColor = .Custom.background

        layoutContentView()
        layoutNavigationView()
        layoutBookInformationView()
        layoutButtonContainer()
        layoutBorder()
    }

    private func returnToSearchView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure

extension DetailViewController {
    func configure(with viewModel: DetailViewModel) {

        navigationView.beforeButton.rx.tap
            .bind(onNext: returnToSearchView)
            .disposed(by: disposeBag)
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

    func layoutNavigationView() {
        contentsView.addSubview(navigationView)

        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    func layoutBookInformationView() {
        contentsView.addSubview(bookInformationView)

        bookInformationView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
