//
//  AladinEndPoint.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

enum AladinEndPoint {
    case bestSeller(itemType: ItemType)
    case item(name: String, startIndex: Int, itemType: ItemType)
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
        switch self {
        case .item:
            return "/ttb/api/ItemSearch.aspx"
        case .bestSeller:
            return "/ttb/api/ItemList.aspx"
        }
    }

    var queryItem: [String: String] {
        var common: [String: String] = ["TTBKey": apiKey, "Output": "JS", "Version": "20131101"]
        switch self {
        case .item(let name, let startIndex, let itemType):
            common.merge(["Query": name, "startIndex": "\(startIndex)", "SearchTarget": itemType.text]) { current, _ in current }
        case .bestSeller(let itemType):
            common.merge(["QueryType": "Bestseller", "SearchTarget": itemType.text]) { current, _ in current}
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
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

}
