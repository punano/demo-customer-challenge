//
//  HomeViewModel.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator

final class HomeViewModel: BaseViewModel {
    @Injected var movieUseCase: MovieUseCase
    struct Input {
        let searchTrigger: Driver<String?>
        let loadMoreTrigger: Driver<Void>
        let itemSelectTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let data: Driver<[Movie]>
        let loading: Driver<Bool>
        let error: Driver<Void>
    }
    
    var listData = BehaviorRelay<[Movie]>(value: [])
    
    func transform(input: Input) -> Output {
        input.searchTrigger
            .drive(onNext: startSearch)
            .disposed(by: disposeBag)
        
        input.loadMoreTrigger
            .withLatestFrom(input.searchTrigger)
            .drive(onNext: loadMore)
            .disposed(by: disposeBag)
        
        input.itemSelectTrigger
            .drive(onNext: { [weak self] idxPath in
                guard let self = self else { return }
                let item = self.listData.value[idxPath.row]
                self.router.trigger(.detail(item))
            })
            .disposed(by: disposeBag)
        
        let errorHandler = errorTracker
            .asObservable()
            .flatMap({ [weak self] (error) -> Driver<Void> in
                guard let error = error as? APIError else {
                    return Driver.just(())
                }
                self?.router.trigger(.alert("", error.getMessage() ?? error.localizedDescription))
                return Driver.just(())
            }).asDriverOnErrorJustComplete()
        
        return Output(data: listData.asDriverOnErrorJustComplete(),
                      loading: activityIndicator.asDriver(),
                      error: errorHandler)
    }
    
    fileprivate func startSearch(with text: String?) {
        currentPage = 1
        requestSearchAPI(with: text)
    }
    
    fileprivate func loadMore(with text: String?) {
        currentPage += 1
        requestSearchAPI(with: text)
    }
}

// MARK: - Request API
extension HomeViewModel {
    fileprivate func requestSearchAPI(with text: String?) {
        guard let text = text, !text.isEmpty else {
            total = 0
            currentPage = 0
            listData.accept([])
            return
        }
        guard !activityIndicator.isLoading else {
            return
        }
        movieUseCase.searchMovie(with: text, at: currentPage)
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .subscribe(onNext: handleSearchData)
            .disposed(by: disposeBag)
    }
    
    fileprivate func handleSearchData(_ result: PaggingResult<Movie>) {
        var list = listData.value
        currentPage = result.page ?? currentPage
        total = result.totalResults.int ?? 0
        if currentPage == 1 {
            list = result.search
        } else {
            list.append(contentsOf: result.search)
        }
        shouldLoadMore.onNext(total > list.count)
        listData.accept(list)
    }
}
