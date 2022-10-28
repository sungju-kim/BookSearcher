//
//  NetworkError.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case failToDecode
    case emptyData
    case response(code: Int)
}
