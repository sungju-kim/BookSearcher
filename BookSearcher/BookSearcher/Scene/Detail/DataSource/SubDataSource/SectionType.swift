//
//  SectionType.swift
//  BookSearcher
//
//  Created by dale on 2022/11/02.
//

import Foundation

@frozen enum SectionType: Int, CaseIterable {
    case banner = 0
    case button
    case bookInfo
    case starRate
    case review
    case publish
}

