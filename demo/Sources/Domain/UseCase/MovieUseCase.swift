//
//  MovieUseCase.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import RxSwift

protocol MovieUseCase {
    func searchMovie(with keyWord: String, at page: Int) -> Observable<PaggingResult<Movie>>
}
