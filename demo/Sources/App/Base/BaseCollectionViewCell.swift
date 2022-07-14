//
//  BaseCollectionViewCell.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import RxSwift

protocol CollectionViewModelProtocol {
    
}

class BaseCollectionViewCell<T: CollectionViewModelProtocol>: UICollectionViewCell, ReuseID {
    typealias ViewModel = T
    var viewModel: ViewModel!
    var indexPath: IndexPath!
    let disposeBag = DisposeBag()
    
    final func config(with viewModel: T, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        self.setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func configUI() {}
    func setupCell() {}
}

class BaseCollectionViewModel<T: Codable>: NSObject, CollectionViewModelProtocol {
    var data: T!
    
    init(with data: T) {
        super.init()
        self.data = data
        self.setupViewModel()
    }
    
    func setupViewModel() {}
}
