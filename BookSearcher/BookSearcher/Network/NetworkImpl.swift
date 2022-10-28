//
//  NetworkImpl.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation
import RxSwift

final class NetworkImpl: Network {
    func fetch(endPoint: Requestable) -> Single<Data> {
        return Single.create { observer in
            guard let request = endPoint.urlRequest else {
                observer(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }

            URLSession.shared.dataTask(with: request) { data, response, _ in
                guard let response = response as? HTTPURLResponse else { return }
                guard (200..<300) ~= response.statusCode else {
                    observer(.failure(NetworkError.response(code: response.statusCode)))
                    return
                }

                guard let data = data else {
                    observer(.failure(NetworkError.emptyData))
                    return
                }
                observer(.success(data))
            }.resume()
            return Disposables.create()
        }
    }
}
