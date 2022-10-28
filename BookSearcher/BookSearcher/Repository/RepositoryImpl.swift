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

    func search(bookName: String, startIndex: Int) -> Single<Data> {
        return network.fetch(endPoint: GoogleBooksEndPoint.books(bookName: bookName, startIndex: startIndex))
    }

    func search(magazineName: String, startIndex: Int) -> Single<Data> {
        return network.fetch(endPoint: GoogleBooksEndPoint.magazines(magazineName: magazineName, startIndex: startIndex))
    }
}
