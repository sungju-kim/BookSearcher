//
//  SearchViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import UIKit
import RxSwift
import RxRelay

final class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var beforeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.left")
        configuration.baseForegroundColor = .Custom.placeholder
        let button = UIButton(configuration: configuration)
        return button
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(.init(), for: .search, state: .normal)
        searchBar.setImage(UIImage(systemName: "xmark"), for: .clear, state: .normal)
        searchBar.searchTextField.tintColor = .Custom.placeholder
        searchBar.searchTextField.backgroundColor = .clear
        let attribute = NSAttributedString(string: "Play 북에서 검색",
                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.Custom.placeholder,
                                                       NSAttributedString.Key.font: UIFont.customFont(ofSize: 18, weight: .regular)])
        searchBar.searchTextField.attributedPlaceholder = attribute
        searchBar.searchTextField.textColor = .Custom.textGray
        return searchBar
    }()

    private lazy var navigationContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        [beforeButton, searchBar].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    // MARK: TODO - ViewModel로 로직 이동 필요
    let beforeButtonTapped = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Custom.background
        view.layer.cornerRadius = 5

        layoutNavigationContainer()
        layoutBorder()

        beforeButton.rx.tap
            .bind(to: beforeButtonTapped)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Section

private extension SearchViewController {
    func layoutNavigationContainer() {
        view.addSubview(navigationContainer)

        navigationContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func layoutBorder() {
        view.addSubview(border)

        border.snp.makeConstraints { make in
            make.top.equalTo(navigationContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
