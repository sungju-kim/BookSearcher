//
//  UIFont + extension.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit.UIFont

extension UIFont {
    class func customFont(ofSize: CGFloat, weight: CustomWeight) -> UIFont? {
        return UIFont(name: weight.fontName, size: ofSize)
    }

    enum CustomWeight: String {
        case medium = "Medium"
        case regular = "Regular"
        case semibold = "Semibold"
        case bold = "Bold"

        private var fontType: String {
            return "SFProDisplay"
        }

        private var weight: String {
            return rawValue
        }

        var fontName: String {
            return "\(fontType)-\(weight)"
        }
    }
}
