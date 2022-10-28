//
//  SceneDelegate.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let viewController = MainViewController()
        let viewModel = MainViewModel()
        viewController.configure(with: viewModel)

        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        window?.backgroundColor = .Custom.background
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
