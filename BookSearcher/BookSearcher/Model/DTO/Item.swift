//
//  Item.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

struct Item: Decodable {
    let title: String?
    let link: String?
    let author, pubDate, itemDescription: String?
    let creator: String?
    let itemID, priceSales, priceStandard: Int?
    let imageURL: String?
    let publisher: String?
    let customerReviewRank: Int?
    let mallType: String?
    let isbn: String?
    let isbn13: String?
    let subInfo: SubInfo?

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, creator, isbn, isbn13
        case priceSales, priceStandard, mallType
        case publisher, customerReviewRank, subInfo
        case itemDescription = "description"
        case itemID = "itemId"
        case imageURL = "cover"
    }
}

struct SubInfo: Decodable {
    let subTitle, originalTitle: String?
    let itemPage: Int?
    let ratingInfo: RatingInfo?
    let reviewList: [Review]?
}

extension SubInfo {
    func mockReviewList() -> [Review] {
        guard let count = ratingInfo?.ratingCount else { return [] }
        return (0..<count).map {Review(reviewRank: Int.random(in: 0...10), writer: "\($0)writer", link: "\($0)link", title: "\($0)title")}
    }
}

struct RatingInfo: Decodable {
    let ratingScore: Double
    let ratingCount, commentReviewCount, myReviewCount: Int
}

struct Review: Decodable {
    let reviewRank: Int
    let writer, link, title: String
}

// Mock URL - API 포함되지 않은 정보입니다.
extension Review {
    var imageURL: String {
        return "https://user-images.githubusercontent.com/78553659/199285029-bc78a84b-ad54-4e9d-93f7-87f4b12df5aa.jpeg"
    }
}

enum ItemType: Int, CaseIterable {
    case book
    case music

    var text: String {
        switch self {
        case .book:
            return "Book"
        case .music:
            return "Music"
        }
    }

    var title: String {
        switch self {
        case .book:
            return "최다 판매 Book"
        case .music:
            return "최다 판매 음반"
        }
    }
}
