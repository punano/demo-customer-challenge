//
//  GeneralResult.swift
//  Stil
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation

struct PaggingResult<T: Codable>: Codable {
    var totalResults: String
    var page: Int?
    var search: [T]
    
    enum CodingKeys: String, CodingKey {
        case totalResults, page
        case search = "Search"
    }
}

struct API {
    struct Parameters {
        static let apiKey = "apikey"
        static let searchQuery = "s"
        static let movieId = "i"
        static let type = "type"
        static let page = "page"
        
        static var defaultParameters: [String: Any] {
            return [
                API.Parameters.apiKey: AppManager.shared.appConfig.apiKey,
                API.Parameters.type: "movie"
            ]
        }
    }
}
