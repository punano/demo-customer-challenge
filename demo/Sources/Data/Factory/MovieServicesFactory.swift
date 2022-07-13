//
//  MovieServicesFactory.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

final class MovieServicesFactory: BaseServiceFactory {
    func searchMovieRequest() -> BaseRequest<PaggingResult<Movie>> {
        let request = urlRequest(path: "", method: .get)
        return BaseRequest<PaggingResult<Movie>>(request: request)
    }
}
