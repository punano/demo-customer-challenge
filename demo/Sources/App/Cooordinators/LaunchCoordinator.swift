//
//  LaunchCoordinator.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import XCoordinator

enum LaunchRoute: Route {
    case home
}

class LaunchCoordinator: ViewCoordinator<LaunchRoute> {
    
    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
        super.init(rootViewController: viewController)
        viewController.viewModel = LaunchViewModel(router: weakRouter)
    }
    
    open override func prepareTransition(for route: RouteType) -> TransitionType {
        switch route {
        case .home:
            let coordinator = HomeCoordinator(initialRoute: .home)
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            return .presentOnRoot(coordinator)
        }
    }
}
