//
//  MovieCollectionCell.swift
//  demo
//
//  Created by Gà Nguy Hiểm on 13/07/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class MovieCollectionCell: BaseCollectionViewCell<MovieCollectionCellViewModel> {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    
    @IBOutlet private weak var imageWidth: NSLayoutConstraint!
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
    
    override func configUI() {
        imageWidth.constant = UIScreen.main.bounds.width * 0.45
        imageHeight.constant = UIScreen.main.bounds.height * 0.3
    }
    
    override func setupCell() {
        titleLabel.text = viewModel.data.title
        yearLabel.text = viewModel.data.year
        posterImageView.sd_imageTransition = SDWebImageTransition.fade(duration: 0.5)
        posterImageView.sd_setImage(with: URL(string: viewModel.data.poster),
                                  placeholderImage: UIImage(named: "logo"),
                                  options: [ .retryFailed, .continueInBackground, .waitStoreCache],
                                  completed: nil)
    }
}
