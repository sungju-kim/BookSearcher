//
//  Injector.swift
//  BookSearcher
//
//  Created by dale on 2022/10/28.
//

import Foundation

@propertyWrapper
struct Injector<T> {
    var wrappedValue: T

    init(keypath: KeyPath<RepositoryContainer, T>) {
        let container = RepositoryContainer.shared
        wrappedValue = container[keyPath: keypath]
    }
}
