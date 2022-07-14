//
//  Movie.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import UIKit

enum MovieType: String, Codable {
    case movie = "movie"
}

struct Movie: Codable {
    var title: String?
    var year: String?
    var imdbID: String?
    var type: MovieType?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
