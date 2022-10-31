//
//  CustomNavigationBar.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class CustomNavigationView: UIView {
    private(set) var beforeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.left")
        configuration.baseForegroundColor = .Custom.placeholder
        let button = UIButton(configuration: configuration)
        return button
    }()

    private(set) var searchBar: UISearchBar = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutNavigationContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutNavigationContainer()
    }
}

// MARK: - Layout Section

private extension CustomNavigationView {
    func layoutNavigationContainer() {
        addSubview(navigationContainer)

        navigationContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
}
