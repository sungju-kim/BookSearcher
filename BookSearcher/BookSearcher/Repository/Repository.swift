//
//  Repository.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

protocol Repository {
    func searchItem(name: String, startIndex: Int, itemType: ItemType) -> Single<SearchResult>
    func searchBestSeller(itemType: ItemType) -> Single<SearchResult>
    func searchInformation(id: String) -> Single<SearchResult>
    func downLoadImage(url: String) -> Single<Data>
}
