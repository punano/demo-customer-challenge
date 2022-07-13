//
//  DetailViewModel.swift
//  demo
//
//  Created by Quan Nguyen on 23/12/2020.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator
import UIKit

class DetailViewModel: BaseViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<Movie?>
    }
    private var data: Movie!
    private let localObserData = BehaviorSubject<Movie?>(value: nil)
    
    init(with router: WeakRouter<HomeRoute>, data: Movie) {
        super.init(with: router)
        self.data = data
    }
    
    required public init(with router: WeakRouter<HomeRoute>) {
        super.init(with: router)
    }
    
    func transform(input: Input) -> Output {
        input.loadTrigger
            .drive(onNext: { [weak self] in
                self?.localObserData.onNext(self?.data)
            })
            .disposed(by: disposeBag)
        
        return Output(data: localObserData.asDriverOnErrorJustComplete())
    }
}
