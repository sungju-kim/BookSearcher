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

    func searchItem(name: String, startIndex: Int, itemType: ItemType) -> Single<SearchResult> {
        return Single.create { observer in
            self.network.fetch(endPoint: AladinEndPoint.items(name: name, startIndex: startIndex, itemType: itemType))
                .subscribe { data in
                    guard let decodedData = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                        observer(.failure(NetworkError.failToDecode))
                        return
                    }
                    observer(.success(decodedData))
                } onFailure: { error in
                    observer(.failure(error))
                }
        }
    }

    func searchBestSeller(itemType: ItemType) -> Single<SearchResult> {
        return Single.create { observer in
            self.network.fetch(endPoint: AladinEndPoint.bestSeller(itemType: itemType))
                .subscribe { data in
                    guard let decodedData = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                        observer(.failure(NetworkError.failToDecode))
                        return
                    }
                    observer(.success(decodedData))
                } onFailure: { error in
                    observer(.failure(error))
                }
        }
    }

    func downLoadImage(url: String) -> Single<Data> {
        // MARK: - TODO - 캐싱 기능구현 필요
        return network.fetch(endPoint: AladinEndPoint.image(url: url))
    }
}
