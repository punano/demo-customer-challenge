//
//  LaunchViewController.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

class LaunchViewController: UIViewController {
    var viewModel: LaunchViewModel!
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLogo()
    }
    
    fileprivate func showLogo() {
        logo.alpha = 0
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.logo.alpha = 1
        } completion: { [weak self] (status) in
            self?.hideLogo()
        }
    }
    
    fileprivate func hideLogo() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) { [weak self] in
            self?.logo.alpha = 0
        } completion: { [weak self] (status) in
            self?.viewModel.router.trigger(.home)
        }

    }
}

