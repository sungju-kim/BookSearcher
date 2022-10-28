//
//  SearchResult.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

struct SearchResult: Decodable {
    let title: String?
    let link: String?
    let totalResults, startIndex, itemsPerPage: Int?
    let item: [Item]?

    enum CodingKeys: String, CodingKey {
        case title, link, totalResults, startIndex, itemsPerPage, item
    }
}
