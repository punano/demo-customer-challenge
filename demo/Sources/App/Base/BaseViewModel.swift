//
//  BaseViewModel.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa
import SwifterSwift

protocol ViewModelProtocol {
    associatedtype RouteType: Route
    var router: WeakRouter<RouteType> { get }
    var disposeBag: DisposeBag { get set }
    init(with router: WeakRouter<RouteType>)
    func back()
}

class BaseViewModel: NSObject, ViewModelProtocol {
    public typealias RouteType = HomeRoute
    public var router: WeakRouter<HomeRoute>
    public var disposeBag: DisposeBag = DisposeBag()
    public let errorTracker = ErrorTracker()
    public let activityIndicator = ActivityIndicator()
    public var currentPage: Int = 0
    public var total: Int = 0
    public var shouldLoadMore = BehaviorSubject<Bool>(value: true)
    
    required public init(with router: WeakRouter<HomeRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.pop)
    }
}

extension UseViewModel where Self: UIViewController {
    static func newInstance(with viewModel: Model) -> Self {
        let viewController = self.initFromNib()
        viewController.bind(to: viewModel)
        return viewController
    }
    
    static func newInstance() -> Self {
        return self.initFromNib()
    }
}

protocol UseViewModel {
    associatedtype Model
    var viewModel: Model! { get set }
    func bind(to model: Model)
}
