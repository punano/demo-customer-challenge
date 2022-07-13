//
//  AppDelegate.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var launchCoordinator = LaunchCoordinator()
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let window = self.window {
            launchCoordinator.setRoot(for: window)
        }
        AppManager.shared.setEnv(with: .development)
        self.window?.makeKeyAndVisible()
        return true
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            MovieRepository() as MovieUseCase
        }
    }
}
