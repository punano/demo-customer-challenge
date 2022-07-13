//
//  MovieRepository.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import RxSwift

struct MovieRepository: MovieUseCase {
    func searchMovie(with keyWord: String, at page: Int) -> Observable<PaggingResult<Movie>> {
        let params: [String: Any] = [
            "s": keyWord,
            "page": page,
            "apikey": AppManager.shared.appConfig.apiKey,
            "type": "movie"
        ]
        return Observable.create { obser in
            PrivateManagerAPI.shared.run(request: MovieServicesFactory().searchMovieRequest(), input: params, completionHandler: { (response) in
                switch response {
                case .success(let result):
                    obser.onNext(result)
                case .failure(let error):
                    obser.onError(error.error)
                }
            })
            return Disposables.create()
        }
    }
}
