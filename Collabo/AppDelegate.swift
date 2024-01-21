//
//  AppDelegate.swift
//  Collabo
//
//  Created by tornike <parunashvili on 15.01.24.
//

import UIKit
import OAuthSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let asanaOAuth = OAuth2Swift(
        consumerKey: "1206344666310503",
        consumerSecret: "385e60c477ccf676ef2759b209126404",
        authorizeUrl: "https://app.asana.com/-/oauth_authorize",
        responseType: "code"
    )

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let state = UUID().uuidString
        guard retrieveAccessTokenFromUserDefaults() == nil else {
            return true
        }
        asanaOAuth.authorize(
            withCallbackURL: "urn:ietf:wg:oauth:2.0:oob",
            scope: "default",
            state: state
        ) { result in
        }
        
        return true
    }
    
    func retrieveAccessTokenFromUserDefaults() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Called 2")
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

