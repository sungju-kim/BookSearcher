//
//  Requestable.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

protocol Requestable {
    var apiKey: String { get }
    var method: HTTPMethod { get }
    var scheme: String { get }
    var base: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryItem: [URLQueryItem] { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}
