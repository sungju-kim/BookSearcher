//
//  MainViewController.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let searchButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.contentInsets = .init(top: Constraint.regular,
                                            leading: Constraint.regular,
                                            bottom: Constraint.regular,
                                            trailing: Constraint.regular)

        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = Constraint.semiRegular

        var titleAttribute: AttributedString = .init("Play 북에서 검색")
        titleAttribute.font = .customFont(ofSize: 18,
                                          weight: .regular)

        configuration.attributedTitle = titleAttribute
        configuration.baseForegroundColor = .Custom.placeholder

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading

        return button
    }()

    private let menuBar = MenuBar()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(ofSize: 28, weight: .regular)
        label.textColor = .Custom.textWhite
        return label
    }()

    private let moreButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.baseForegroundColor = .Custom.selectedItem
        let button = UIButton(configuration: configuration)
        return button
    }()

    private lazy var headerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        [headerLabel, moreButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSearchButton()
        layoutMenuBar()
        layoutHeaderContainer()
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

        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(menuBar.snp.bottom).offset(Constraint.regular)
            make.leading.trailing.equalToSuperview().inset(Constraint.regular)
        }
    }
}
