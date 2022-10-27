//
//  MenuBar + Rx.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import RxSwift
import RxCocoa

extension Reactive where Base: MenuBar {
    var selectedSegmentIndex: ControlProperty<Int> {
        return base.segmentControl.rx.selectedSegmentIndex
    }
}
