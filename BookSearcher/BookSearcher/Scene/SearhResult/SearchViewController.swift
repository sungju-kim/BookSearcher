//
//  SearchViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var viewModel: SearchViewModel?

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

    private let menuBar = MenuBar()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = .clear
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)

        return collectionView
    }()

    private lazy var resultContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isHidden = true

        [menuBar, collectionView].forEach { stackView.addArrangedSubview($0) }

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Custom.background
        view.layer.cornerRadius = 5

        layoutNavigationContainer()
        layoutBorder()
        layoutMenuBar()
    }

    private func showResults(isShown: Bool) {
        resultContainer.isHidden = !isShown
        border.isHidden = isShown
    }

    private func viewWillDismiss() {
        resultContainer.removeFromSuperview()
        searchBar.endEditing(true)
        searchBar.text = nil
        showResults(isShown: false)
    }

    private func viewWillPresent() {
        searchBar.becomeFirstResponder()

        layoutResultContainer()
    }
}
// MARK: - Configure

extension SearchViewController {
    func configure(with viewModel: SearchViewModel) {
        self.viewModel = viewModel

        viewModel.output.presentSearchView
            .bind(onNext: viewWillPresent)
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .map { true }
            .bind(onNext: showResults)
            .disposed(by: disposeBag)

        beforeButton.rx.tap
            .withUnretained(self)
            .do { $0.0.viewWillDismiss() }
            .map { $1 }
            .bind(to: viewModel.input.beforeButtonTapped)
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

    func layoutResultContainer() {
        view.addSubview(resultContainer)

        resultContainer.snp.makeConstraints { make in
            make.top.equalTo(navigationContainer.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func layoutMenuBar() {
        menuBar.snp.makeConstraints { make in
            make.height.equalTo(50)
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
