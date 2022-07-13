//
//  AppConfiguration.swift
//  demo
//
//  Created by Quan Nguyen on 23/12/2020.
//

import Foundation

class AppManager {
    static let shared = AppManager()
    
    enum Enviroment {
        case production
        case development
    }
    
    var appConfig: AppConfiguration = DevConfiguration()
    
    func setEnv(with env: Enviroment) {
        switch env {
        case .development:
            appConfig = DevConfiguration()
        case .production:
            appConfig = ProductionConfiguration()
        }
    }
}

class DevConfiguration: AppConfiguration {
    var baseURL = "https://www.omdbapi.com/"
    var apiKey = "b9bd48a6"
    var defaultKeyword = "Marvel"
}

class ProductionConfiguration: AppConfiguration {
    var baseURL = "https://www.omdbapi.com/"
    var apiKey = "b9bd48a6"
    var defaultKeyword = "Marvel"
}

protocol AppConfiguration {
    var baseURL: String { get }
    var apiKey: String { get }
    var defaultKeyword: String { get }
}
