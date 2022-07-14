//
//  HomeViewController.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
final class HomeViewController: BaseViewController<HomeViewModel> {
    @IBOutlet private weak var searchView: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var triggerLoadMore: Driver<Void>!
    private var triggerReload = PublishSubject<Void>()
    
    override var setting: NavigationSetting {
        return NavigationSetting(isHiddenNavigation: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        super.configUI()
        collectionView.register(nibWithCellClass: MovieCollectionCell.self)
    }
    
    override func configRx() {
        triggerLoadMore = collectionView.rx.contentOffset
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .asDriverOnErrorJustComplete()
            .withLatestFrom(viewModel.shouldLoadMore.asDriverOnErrorJustComplete())
            .flatMap { state in
                return self.collectionView.isNearBottomEdge(edgeOffset: 20.0) && state
                    ? Driver.just(())
                    : Driver.empty()
            }
        collectionView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).mapToVoid()
            .bind(to: triggerReload)
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = HomeViewModel.Input(reloadTrigger: triggerReload.asDriverOnErrorJustComplete(),
                                        searchTrigger: searchView.rx.text.asDriverOnErrorJustComplete(),
                                        loadMoreTrigger: triggerLoadMore,
                                        itemSelectTrigger: collectionView.rx.itemSelected.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.error
            .drive()
            .disposed(by: disposeBag)
        output.loading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    HudManager.shared.showHUD()
                } else {
                    self?.refreshControl.endRefreshing()
                    HudManager.shared.hideHUD()
                }
            })
            .disposed(by: disposeBag)
        output.data
            .do(onNext: { [weak self] data in
                data.count > 0 ? self?.collectionView.restore() : self?.collectionView.setEmptyMessage("No movie found.\nTry to adjust search parameters")
            })
            .drive(collectionView.rx.items) { collectionView, index, element in
                let idxPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withClass: MovieCollectionCell.self, for: idxPath)
                cell.config(with: MovieCollectionCellViewModel(with: element), indexPath: idxPath)
                return cell
            }.disposed(by: disposeBag)
    }
}
