//
//  LaunchViewModel.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import XCoordinator

class LaunchViewModel: NSObject {
    
    let router: WeakRouter<LaunchRoute>
    
    init(router: WeakRouter<LaunchRoute>) {
        self.router = router
    }
}
