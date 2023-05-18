//
//  AppDelegate.swift
//  gallery-project
//
//  Created by Ankush Sharma on 06/04/23.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static var shared = AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        UserDefaults.standard.object(forKey: "token")
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "473403994032-l213bldfqnp4k77muqkligbi59hi260d.apps.googleusercontent.com"
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

