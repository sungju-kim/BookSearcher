//
//  CustomNavigationView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class CustomNavigationView: UIStackView {
    private(set) var beforeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .Icon.left
        configuration.baseForegroundColor = .Custom.placeholder
        let button = UIButton(configuration: configuration)
        return button
    }()

    private(set) var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(.init(), for: .search, state: .normal)
        searchBar.setImage(.Icon.xMark, for: .clear, state: .normal)
        searchBar.searchTextField.tintColor = .Custom.placeholder
        searchBar.searchTextField.backgroundColor = .clear
        let attribute = NSAttributedString(string: .NaigationView.searchBarPlaceholder,
                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.Custom.placeholder,
                                                       NSAttributedString.Key.font: UIFont.customFont(ofSize: 18, weight: .regular)])
        searchBar.searchTextField.attributedPlaceholder = attribute
        searchBar.searchTextField.textColor = .Custom.textGray
        return searchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAttribute()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        setAttribute()
    }

    private func setAttribute() {
        axis = .horizontal
        distribution = .fill
        [beforeButton, searchBar].forEach { addArrangedSubview($0) }
    }
}
