//
//  HomeCoordinator.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import XCoordinator

class HomeCoordinator: NavigationCoordinator<HomeRoute> {
    
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .detail(let data):
            let viewModel = DetailViewModel(with: weakRouter, data: data)
            let viewController = DetailViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .backToHome:
            return .multiple([.popToRoot()])
        case .home:
            let homeViewModel = HomeViewModel(with: weakRouter)
            let viewController = HomeViewController.newInstance(with: homeViewModel)
            return .push(viewController)
        case let .alert(title, message):
            let alertVC = UIAlertController(title: title, message: message)
            return .present(alertVC)
        case .pop:
            return .pop()
        }
    }
}
