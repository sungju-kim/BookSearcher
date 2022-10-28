//
//  Network.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

protocol Network {
    func fetch(endPoint: Requestable) -> Single<Data>
}
