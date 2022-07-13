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
