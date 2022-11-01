//
//  DetailViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit
import RxSwift
import RxRelay
import RxAppState

final class DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var viewModel: DetailViewModel?

    private let navigationView = CustomNavigationView()

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

    private let dataSource = DetailDataSource()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: dataSource.sectionProvider)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .clear

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.identifier)
        collectionView.register(StarRateCell.self, forCellWithReuseIdentifier: StarRateCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(CommonHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CommonHeaderView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .Custom.background

        layoutNavigationView()
        layoutCollectionView()
    }

    private func returnToSearchView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure

extension DetailViewController {
    func configure(with viewModel: DetailViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadData
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { viewController, viewModels in
                viewController.dataSource.configure(with: viewModels)
                viewController.collectionView.reloadData() }
            .disposed(by: disposeBag)

        navigationView.beforeButton.rx.tap
            .bind(onNext: returnToSearchView)
            .disposed(by: disposeBag)

        rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Section

private extension DetailViewController {
    func layoutNavigationView() {
        view.addSubview(navigationView)

        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func layoutCollectionView() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
