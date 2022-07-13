//
//  HomeRoute.swift
//  demo
//
//  Created by user on 22/12/2020.
//

import Foundation
import XCoordinator

enum HomeRoute: Route {
    case detail(Movie)
    case backToHome
    case home
    case alert(String, String)
    case pop
}
