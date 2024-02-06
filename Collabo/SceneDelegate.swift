//
//  SceneDelegate.swift
//  Collabo
//
//  Created by tornike <parunashvili on 15.01.24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let welcomeView = SUIWelcomeView()
        
        let hostingController = UIHostingController(rootView: welcomeView)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }
    
    func switchToMainTabBarController() {
        let tabBarController = UITabBarController()
        
        let homeViewController = HomeViewController()
        homeViewController.viewModel = DefaultHomeViewModel()
        homeViewController.navigator = .init(viewController: homeViewController)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.navigationItem.largeTitleDisplayMode = .always
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let myTasksViewController = UserTaskListViewController()
        myTasksViewController.viewModel = DefaultUserTaskListViewModel()
        myTasksViewController.navigator = .init(viewController: myTasksViewController)
        let myTasksNavigationController = UINavigationController(rootViewController: myTasksViewController)
        myTasksNavigationController.tabBarItem = UITabBarItem(title: "My Tasks", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let accountViewController = AccountViewController()
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        accountNavigationController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.circle"), tag: 2)
        
        tabBarController.viewControllers = [homeNavigationController, myTasksNavigationController, accountNavigationController]
        
        tabBarController.tabBar.applyCustomBackgroundColor()

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    
    func switchToLoginViewController() {
        let loginView = SUILoginView()
        let hostingController = UIHostingController(rootView: loginView)
        
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        if url.scheme == "com.TockProducts.Collabo" {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                print("Authorization code: \(code)")
            }
        }
    }
    
    
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

