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
    let isbn13: String?
    let subInfo: SubInfo?

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, creator, isbn13
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

struct RatingInfo: Decodable {
    let ratingScore: Double
    let ratingCount, commentReviewCount, myReviewCount: Int
}

struct Review: Decodable {
    let reviewRank: Int
    let writer, link, title: String
}

enum ItemType: Int, CaseIterable {
    case eBook
    case music

    var text: String {
        switch self {
        case .eBook:
            return "eBook"
        case .music:
            return "Music"
        }
    }

    var title: String {
        switch self {
        case .eBook:
            return "최다 판매 eBook"
        case .music:
            return "최다 판매 음반"
        }
    }
}
