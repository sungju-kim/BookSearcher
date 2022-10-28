//
//  Repository.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

protocol Repository {
    func searchItem(name: String, startIndex: Int, itemType: ItemType) -> Single<Data>
    func searchBestSeller(itemType: ItemType) -> Single<Data>
}
