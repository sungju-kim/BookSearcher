//
//  CustomButton.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class CustomButton: UIButton {
    convenience init(title: String, image: UIImage? = nil, backgroundColor: UIColor, fontColor: UIColor? = nil) {
        var configuration = UIButton.Configuration.bordered()
        var attribute = AttributedString(title)
        configuration.image = image
        configuration.imagePadding = Constraint.min
        attribute.font = .customFont(ofSize: 13, weight: .regular)
        configuration.attributedTitle = attribute
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = fontColor
        configuration.imagePadding = Constraint.min
        configuration.contentInsets = .init(top: Constraint.semiRegular,
                                            leading: Constraint.regular,
                                            bottom: Constraint.semiRegular,
                                            trailing: Constraint.regular)

        self.init(configuration: configuration)

        self.titleLabel?.font = .customFont(ofSize: 4, weight: .regular)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
}
