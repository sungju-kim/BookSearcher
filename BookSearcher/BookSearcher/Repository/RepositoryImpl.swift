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
    private let imageCache: NSCache = NSCache<NSString, NSData>()

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

    func searchInformation(id: String) -> Single<SearchResult> {
        return Single.create { observer in
            self.network.fetch(endPoint: AladinEndPoint.item(id: id))
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
        return Single.create { observer in
            if let image = self.imageCache.object(forKey: url as NSString) {
                observer(.success(image as Data))
                return Disposables.create()
            }

            return self.network.fetch(endPoint: AladinEndPoint.image(url: url))
                .subscribe { data in
                    self.imageCache.setObject(data as NSData, forKey: url as NSString)
                    observer(.success(data))
                } onFailure: { error in
                    observer(.failure(error))
                }
        }
    }

}
