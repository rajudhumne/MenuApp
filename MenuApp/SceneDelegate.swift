//
//  SceneDelegate.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
    
        let networkManager = NetworkManager(session: .shared)
        let viewmodel = MenuViewModelImpl(menuRepository:
                                            MenuRepository(networkManager: networkManager))
        
        // Initialize Root View Controller
        let menuViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController { coder in
            MenuViewController(coder: coder, viewModel: viewmodel)
        }
        
        let rootViewController = UINavigationController(rootViewController: menuViewController ?? UIViewController())
        
        // Initialize Window
        window = UIWindow(windowScene: windowScene)
        
        // Configure Window
        window?.rootViewController = rootViewController
        
        // Make Window Key Window
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }


}

