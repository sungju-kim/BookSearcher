//
//  GoogleBooksEndPoint.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

enum GoogleBooksEndPoint {
    case search(bookName: String, startIndex: Int)
}

extension GoogleBooksEndPoint: Requestable {
    var apiKey: String {
        guard let file = Bundle.main.path(forResource: "Info", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("Info.plist에 API Key를 설정해주세요.")}
        return key
    }

    var method: HTTPMethod {
        return .get
    }

    var scheme: String {
        return "https"
    }

    var base: String {
        return "www.googleapis.com"
    }

    var path: String {
        return "/books/v1/volumes"
    }

    var queryItem: [URLQueryItem] {
        switch self {
        case .search(let bookName, let startIndex):
            return ["q": bookName, "startIndex": "\(startIndex)", "key": apiKey].map { URLQueryItem(name: $0.key, value: $0.value) }
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var url: URL? {
        var component = URLComponents(string: base)
        component?.scheme = scheme
        component?.path.append(path)
        component?.queryItems = queryItem
        return component?.url
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil}
        var request = URLRequest(url: url)
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

}
