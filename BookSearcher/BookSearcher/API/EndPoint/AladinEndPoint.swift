//
//  AladinEndPoint.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

enum AladinEndPoint {
    case eBook(name: String, startIndex: Int)
    case music(name: String, startIndex: Int)
}

extension AladinEndPoint: Requestable {
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
        return "www.aladin.co.kr"
    }

    var path: String {
        return "/ttb/api/ItemList.aspx"
    }

    var queryItem: [String: String] {
        var common: [String: String] = ["TTBKey": apiKey, "Output": "JS"]
        switch self {
        case .eBook(let book, let startIndex):
            common.merge(["Query": book, "startIndex": "\(startIndex)", "SearchTarget": "eBook"]) { current, _ in current }
        case .music(let music, let startIndex):
            common.merge(["Query": music, "startIndex": "\(startIndex)", "SearchTarget": "Music"]) { current, _ in current }
        }
        return common
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var url: URL? {
        var component = URLComponents(string: base)
        component?.scheme = scheme
        component?.path.append(path)
        component?.queryItems = queryItem.map { URLQueryItem(name: $0.key, value: $0.value) }
        return component?.url
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil}
        var request = URLRequest(url: url)
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

}
