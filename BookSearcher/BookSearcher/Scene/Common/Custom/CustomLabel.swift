//
//  CustomLabel.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class CustomLabel: UILabel {
    convenience init(fontColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.CustomWeight) {
        self.init()
        textColor = fontColor
        font = .customFont(ofSize: fontSize, weight: fontWeight)
    }
}
