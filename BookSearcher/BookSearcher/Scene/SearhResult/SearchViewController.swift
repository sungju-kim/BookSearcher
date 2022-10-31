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

    private lazy var navigationView = CustomNavigationView()

    private let menuBar = MenuBar()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    private let collectionView: UICollectionView = {
        let section: NSCollectionLayoutSection = .init(itemWidth: .fractionalWidth(1),
                                                       itemHeight: .fractionalHeight(1),
                                                       groupWidth: .fractionalWidth(1),
                                                       groupHeight: .fractionalHeight(0.15),
                                                       contentInset: .init(top: 8, leading: 8, bottom: 8, trailing: 8))

        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        view.superview?.backgroundColor = .Custom.background
        view.layer.cornerRadius = 5

        layoutNavigationView()
        layoutBorder()
        layoutMenuBar()
    }

    private func showResults(isShown: Bool) {
        resultContainer.isHidden = !isShown
        border.isHidden = isShown
    }

    private func viewWillDismiss() {
        resultContainer.removeFromSuperview()
        navigationView.searchBar.endEditing(true)
        navigationView.searchBar.text = nil
        showResults(isShown: false)
    }

    private func viewWillPresent() {
        navigationView.searchBar.becomeFirstResponder()

        layoutResultContainer()
    }

    private func pushDetailView(with viewModel: DetailViewModel) {
        let viewController = DetailViewController()
        viewController.configure(with: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - Configure

extension SearchViewController {
    func configure(with viewModel: SearchViewModel) {
        self.viewModel = viewModel

        viewModel.output.presentSearchView
            .bind(onNext: viewWillPresent)
            .disposed(by: disposeBag)

        viewModel.output.loadedData
            .bind(to: collectionView.rx.items(cellIdentifier: SearchResultCell.identifier, cellType: SearchResultCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel) }
            .disposed(by: disposeBag)

        viewModel.output.prepareForPush
            .bind(onNext: pushDetailView)
            .disposed(by: disposeBag)

        navigationView.searchBar.rx.searchButtonClicked
            .withLatestFrom(navigationView.searchBar.rx.text)
            .compactMap { $0 }
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposeBag)

        navigationView.searchBar.rx.searchButtonClicked
            .map { true }
            .bind(onNext: showResults)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)

        menuBar.rx.selectedSegmentIndex
            .bind(to: viewModel.input.selectedIndex)
            .disposed(by: disposeBag)

        navigationView.beforeButton.rx.tap
            .withUnretained(self)
            .do { $0.0.viewWillDismiss() }
            .map { $1 }
            .bind(to: viewModel.input.beforeButtonTapped)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Section

private extension SearchViewController {
    func layoutNavigationView() {
        view.addSubview(navigationView)

        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func layoutResultContainer() {
        view.addSubview(resultContainer)

        resultContainer.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
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
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
