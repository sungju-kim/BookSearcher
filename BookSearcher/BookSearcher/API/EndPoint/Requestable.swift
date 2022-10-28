//
//  Requestable.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

protocol Requestable {
    var apiKey: String { get }
    var baseURL: URL? { get }
    var path: String { get }
    var url: URL? { get }
    var headers: [String: String]? { get }
    var parameter: [String: Any] { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case get = "GET"
}
