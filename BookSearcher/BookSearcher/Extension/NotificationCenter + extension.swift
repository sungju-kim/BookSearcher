//
//  NotificationCenter + extension.swift
//  BookSearcher
//
//  Created by dale on 2022/11/03.
//

import UIKit
import RxSwift

extension NotificationCenter {
    static var keyboardWillShowHeight: Observable<CGFloat> {
        NotificationCenter.default.rx.notification(UIWindow.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
    }
    static var keyboardWillHideHeight: Observable<CGFloat> {
        NotificationCenter.default.rx.notification(UIWindow.keyboardWillHideNotification)
            .map { _ in 0 }
    }
}
