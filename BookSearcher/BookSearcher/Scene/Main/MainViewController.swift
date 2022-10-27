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

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSearchButton()
        layoutMenuBar()
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
}
