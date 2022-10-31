//
//  AladinEndPoint.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

enum AladinEndPoint {
    case bestSeller(itemType: ItemType)
    case items(name: String, startIndex: Int, itemType: ItemType)
    case image(url: String)
    case item(id: String)
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
        switch self {
        case.image(let url):
            return url
        default:
            return "www.aladin.co.kr"
        }
    }

    var path: String {
        switch self {
        case .items:
            return "/ttb/api/ItemSearch.aspx"
        case .bestSeller:
            return "/ttb/api/ItemList.aspx"
        case .item:
            return "/ttb/api/ItemLookUp.aspx"
        default:
            return ""
        }
    }

    var queryItem: [String: String] {
        var common: [String: String] = ["TTBKey": apiKey, "Output": "JS", "Version": "20131101"]
        switch self {
        case .items(let name, let startIndex, let itemType):
            common.merge(["Query": name, "startIndex": "\(startIndex)", "SearchTarget": itemType.text]) { current, _ in current }
        case .bestSeller(let itemType):
            common.merge(["QueryType": "Bestseller", "SearchTarget": itemType.text]) { current, _ in current}
        case .item(let id):
            common.merge(["ItemID": id, "ItemIdType": "ISBN", "OptResult": "ratingInfo, reviewList"]) { current, _ in current}
        default:
            break
        }
        return common
    }

    var headers: [String: String] {
        switch self {
        case .image:
            return [:]
        default:
            return ["Content-Type": "application/json"]
        }
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
