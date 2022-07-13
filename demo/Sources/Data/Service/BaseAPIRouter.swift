//
//  BaseAPIRouter.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

class BaseAPIRouter {
    static var baseUrlString: String = AppManager.shared.appConfig.baseURL
//    static var baseUrlString: String = "http://192.168.1.14:5000/api"
    static var baseURL: String {
        return baseUrlString
    }
}
