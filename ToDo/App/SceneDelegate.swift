//
//  SceneDelegate.swift
//  ToDo
//
//  Created by Vika on 17.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: makeTaskListViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func makeTaskListViewController() -> TaskListViewController {
        let store = CoreDataTaskItemStore()
        let vc = TaskListViewController(store: store)
        return vc
    }
}

