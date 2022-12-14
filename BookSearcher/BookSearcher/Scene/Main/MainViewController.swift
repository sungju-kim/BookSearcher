//
//  MainViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import RxSwift
import RxAppState
import SnapKit

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var viewModel: MainViewModel?

    private let searchButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.contentInsets = .init(top: Constraint.regular,
                                            leading: Constraint.regular,
                                            bottom: Constraint.regular,
                                            trailing: Constraint.regular)

        configuration.image = .Icon.magnifyingGlass
        configuration.imagePadding = Constraint.semiRegular

        var titleAttribute = AttributedString(stringLiteral: .NaigationView.searchBarPlaceholder)
        titleAttribute.font = .customFont(ofSize: 18,
                                          weight: .regular)

        configuration.attributedTitle = titleAttribute
        configuration.baseForegroundColor = .Custom.placeholder

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading

        return button
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private let menuBar = MenuBar()

    private let headerLabel: UILabel = CustomLabel(fontColor: .Custom.textWhite,
                                                   fontSize: 28,
                                                   fontWeight: .regular)

    private let moreButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .Icon.right
        configuration.baseForegroundColor = .Custom.selectedItem
        let button = UIButton(configuration: configuration)
        return button
    }()

    private let headerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally

        return stackView
    }()

    private let collectionView: UICollectionView = {
        let section: NSCollectionLayoutSection = .init(itemWidth: .fractionalWidth(1),
                                                       itemHeight: .fractionalHeight(1),
                                                       groupWidth: .fractionalWidth(0.3),
                                                       groupHeight: .fractionalWidth(0.5),
                                                       contentInset: .init(top: 8, leading: 8, bottom: 8, trailing: 8))
        section.orthogonalScrollingBehavior = .continuous

        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MostSoldCell.self,
                                forCellWithReuseIdentifier: MostSoldCell.identifier)

        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSearchButton()
        layoutMenuBar()
        layoutHeaderContainer()
        layoutCollectionView()
        layoutContainerView()
    }

    private func presentSearchView() {
        guard let searchView = self.children.first?.view else { return }
        searchView.backgroundColor = .Custom.animateGray

        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = false
            searchView.backgroundColor = .Custom.background

            self.containerView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            self.view.layoutIfNeeded()
        }
    }

    private func dismissSearchView() {
        guard let searchView = self.children.first?.view else { return }

        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.remakeConstraints { make in
                make.edges.equalTo(self.searchButton)
            }

            searchView.backgroundColor = .Custom.animateGray
            self.view.layoutIfNeeded()
        } completion: { self.containerView.isHidden = $0 }
    }

    private func pushDetailView(with viewModel: DetailViewModel) {
        let viewController = DetailViewController()
        viewController.configure(with: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func setChildViewController(viewModel: SearchViewModel) {
        let searchViewController = SearchViewController()
        searchViewController.configure(with: viewModel)

        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.view.frame = containerView.frame
        navigationController.isNavigationBarHidden = true
        addChild(navigationController)
        containerView.addSubview(navigationController.view)
    }
}

// MARK: - Configure

extension MainViewController {
    func configure(with viewModel: MainViewModel) {
        self.viewModel = viewModel

        viewModel.output.loadedData
            .bind(to: collectionView.rx.items(cellIdentifier: MostSoldCell.identifier,
                                              cellType: MostSoldCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel) }
            .disposed(by: disposeBag)

        viewModel.output.selectedMenu
            .withUnretained(self)
            .bind { viewController, itemType in
                viewController.headerLabel.text = itemType.title }
            .disposed(by: disposeBag)

        viewModel.output.didLoadSearchViewModel
            .bind(onNext: setChildViewController)
            .disposed(by: disposeBag)

        viewModel.output.showSearchView
            .bind(onNext: presentSearchView)
            .disposed(by: disposeBag)

        viewModel.output.dismissSearchView
            .bind(onNext: dismissSearchView)
            .disposed(by: disposeBag)

        viewModel.output.prepareForPush
            .bind(onNext: pushDetailView)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .bind(to: viewModel.input.searchButtonTapped)
            .disposed(by: disposeBag)

        menuBar.rx.selectedSegmentIndex
            .bind(to: viewModel.input.selectedIndex)
            .disposed(by: disposeBag)

        rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Section

private extension MainViewController {
    func layoutSearchButton() {
        view.addSubview(searchButton)

        searchButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constraint.regular)
        }
    }

    func layoutMenuBar() {
        view.addSubview(menuBar)

        menuBar.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalTo(searchButton)
            make.height.equalTo(50)
        }
    }

    func layoutHeaderContainer() {
        view.addSubview(headerContainer)

        [headerLabel, moreButton].forEach { headerContainer.addArrangedSubview($0) }

        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(menuBar.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalToSuperview().inset(Constraint.regular)
        }
    }

    func layoutCollectionView() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalToSuperview().offset(Constraint.regular)
            make.bottom.equalToSuperview()
        }
    }

    func layoutContainerView() {
        view.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(searchButton)
        }
    }
}
