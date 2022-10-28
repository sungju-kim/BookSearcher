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

    var scheme: String {
        return "https"
    }

    var base: String {
        return "www.googleapis.com"
    }

    var path: String {
        return "/books/v1/volumes"
    }

    var url: URL? {
        var component = URLComponents(string: base)
        component?.scheme = scheme
        component?.path.append(path)
        component?.queryItems = queryItem
        return component?.url
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var queryItem: [URLQueryItem] {
        switch self {
        case .search(let bookName, let startIndex):
            return ["q": bookName, "startIndex": "\(startIndex)", "key": apiKey].map { URLQueryItem(name: $0.key, value: $0.value) }
        }
    }

    var method: HTTPMethod {
        return .get
    }
}
