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

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, creator
        case priceSales, priceStandard, mallType
        case publisher, customerReviewRank
        case itemDescription = "description"
        case itemID = "itemId"
        case imageURL = "cover"
    }
}
