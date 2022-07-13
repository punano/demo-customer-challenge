//
//  DetailViewController.swift
//  demo
//
//  Created by Quan Nguyen on 23/12/2020.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class DetailViewController: BaseViewController<DetailViewModel> {
    @IBOutlet weak var imageContainView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override var setting: NavigationSetting {
        return NavigationSetting(title: "Details",
                                 isHiddenNavigation: false)
    }
    
    override func configUI() {
        super.configUI()
        imageContainView.sd_imageTransition = SDWebImageTransition.fade(duration: 0.5)
    }
    
    override func bind() {
        let input = DetailViewModel.Input(loadTrigger: rx.viewWillAppear
                                            .mapToVoid()
                                            .asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
    
        output.data
            .drive(dataBinding)
            .disposed(by: disposeBag)
    }
    
    private var dataBinding: Binder<Movie?> {
        return Binder(self, binding: { [weak self] (vc, movie) in
            guard let movie = movie else { return }
            self?.imageContainView.sd_setImage(with: URL(string: movie.poster),
                                         placeholderImage: UIImage(named: "logo"),
                                         options: [ .retryFailed, .continueInBackground, .waitStoreCache],
                                         completed: nil)
            self?.titleLabel.text = movie.title
            self?.descriptionLabel.text = movie.year
        })
    }
}
