//
//  AppDelegate.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 05.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator()
        window?.rootViewController = coordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }

}

