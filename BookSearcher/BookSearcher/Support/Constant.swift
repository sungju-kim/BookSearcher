//
//  Constant.swift
//  BookSearcher
//
//  Created by dale on 2022/11/03.
//

import Foundation
import UIKit.UIImage

// MARK: - String + extension

extension String {
    enum NaigationView {
        static let searchBarPlaceholder = "알라딘에서 검색"
    }

    enum Toast {
        static let addWishList = "위시리스트에 추가 되었습니다."
    }

    enum Button {
        static let moveDetail = "자세히 보기"
        static let addWishList = "위시리스트에 추가"
    }

    enum Rating {
        static let headerText = "평점 및 리뷰정보"
    }
}

// MARK: - UIIMage + extension

extension UIImage {
    enum Icon {
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
        static let left = UIImage(systemName: "chevron.left")
        static let right = UIImage(systemName: "chevron.right")
        static let bookMark = UIImage(systemName: "bookmark.square")
        static let star = UIImage(systemName: "star")
        static let filledStar = UIImage(systemName: "star.fill")
        static let xMark = UIImage(systemName: "xmark")
    }
}
