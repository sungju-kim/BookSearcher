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

    private let navigationView = {
       let navigationView = CustomNavigationView()
        navigationView.searchBar.searchTextField.isHidden = true
        return navigationView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let contentView = UIView()

    private let bannerView = BannerView()

    private let buttonView = ButtonView()

    private let bookInfoView = BookInfoView()

    private let ratingView = RatingView()

    private let reviewList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .Custom.background

        layoutNavigationView()
        layoutScrollView()
        layoutContentView()
        layoutBannerView()
        layoutButtonView()
        layoutBookInfoView()
        layoutRatingView()
        layoutReviewList()
    }

    private func returnToSearchView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure

extension DetailViewController {
    func configure(with viewModel: DetailViewModel) {
        self.viewModel = viewModel

        viewModel.output.didLoadBannerViewModel
            .bind(onNext: bannerView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadButtonViewModel
            .bind(onNext: buttonView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadBookInfoViewModel
            .bind(onNext: bookInfoView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadRatingViewModel
            .observe(on: MainScheduler.instance)
            .bind(onNext: ratingView.configure)
            .disposed(by: disposeBag)

        viewModel.output.didLoadReview
            .bind(to: reviewList.rx.items(cellIdentifier: ReviewCell.identifier, cellType: ReviewCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel) }
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

    func layoutScrollView() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func layoutContentView() {
        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1000)
        }
    }

    func layoutBannerView() {
        contentView.addSubview(bannerView)

        bannerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    func layoutButtonView() {
        contentView.addSubview(buttonView)

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func layoutBookInfoView() {
        contentView.addSubview(bookInfoView)

        bookInfoView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func layoutRatingView() {
        contentView.addSubview(ratingView)

        ratingView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func layoutReviewList() {
        contentView.addSubview(reviewList)

        reviewList.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
