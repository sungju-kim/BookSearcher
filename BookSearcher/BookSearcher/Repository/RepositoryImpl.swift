//
//  RepositoryImpl.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

final class RepositoryImpl: Repository {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func searchItem(name: String, startIndex: Int, itemType: ItemType) -> Single<Data> {
        return network.fetch(endPoint: AladinEndPoint.item(name: name, startIndex: startIndex, itemType: itemType))
    }

    func searchBestSeller(itemType: ItemType) -> Single<Data> {
        return network.fetch(endPoint: AladinEndPoint.bestSeller(itemType: itemType))
    }
}
