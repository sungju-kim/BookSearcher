//
//  Repository.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

protocol Repository {
    func search(bookName: String, startIndex: Int) -> Single<Data>
    func search(magazineName: String, startIndex: Int) -> Single<Data>
}
