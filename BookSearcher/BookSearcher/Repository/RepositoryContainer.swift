//
//  RepositoryContainer.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

final class RepositoryContainer {
    private init() {}

    static var shared = RepositoryContainer()
    private let network: Network = NetworkImpl()

    lazy var repository: Repository = RepositoryImpl(network: network)
}
