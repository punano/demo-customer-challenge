//
//  BaseViewController.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit
import RxSwift

struct NavigationSetting {
    var title: String? = nil
    var isHiddenNavigation: Bool = false
    var isHasBackButton: Bool = true
    var backImage: String = "ic_arrow_back_black"
    var navigationColor: UIColor = UIColor.systemBackground
    var navigationShadow: UIImage? = nil
    var rightButtons: [UIBarButtonItem]? = nil
}

protocol BaseAlert {
    func alert(title: String?,
               message: String,
               buttonTittle: String?,
               handler: ((String?) -> Void)?)
}


class BaseViewController<T: ViewModelProtocol>: UIViewController, UseViewModel, BaseAlert {
    public typealias Model = T
    var disposeBag = DisposeBag()
    var viewModel: Model!
    var bottomConstraint: NSLayoutConstraint?
  
    var refreshControl = UIRefreshControl()
    
    public var setting: NavigationSetting {
        return NavigationSetting()
    }
    
    open func bind(to model: Model) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configUI()
        configRx()
        bind()
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func bind() {}
    
    func configUI() {
        refreshControl.tintColor = .clear
    }
    
    func configRx() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        UIApplication.shared.statusBarStyle = .lightContent
        title = setting.title
        navigationController?.navigationBar.isHidden = setting.isHiddenNavigation
        styleNavigation()
    }
    
    private func styleNavigation() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.shadowImage = setting.navigationShadow
        let backgroundColor = UIImage(color: setting.navigationColor, size: CGSize(width: 1, height: 1))
        navigationController?.navigationBar.setBackgroundImage(backgroundColor, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label,
                                                                   .font: UIFont.systemFont(ofSize: 16, weight: .medium)
                                                                   ]
        navigationController?.navigationBar.isTranslucent = false
        if setting.isHasBackButton {
            let backItem = UIBarButtonItem(
                image: UIImage(named: setting.backImage),
                style: .plain,
                target: self,
                action: #selector(backAction))
            navigationItem.leftBarButtonItem = backItem
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: nil,
                style: .plain,
                target: self,
                action: nil)
        }
        if let rightButtons = setting.rightButtons {
            navigationItem.rightBarButtonItems = rightButtons
        } else {
            navigationItem.rightBarButtonItems = nil
        }
        view.layoutIfNeeded()
    }

    func alert(title: String?,
               message: String,
               buttonTittle: String? = "OK",
               handler: ((String?) -> Void)? = nil) {
        let alertController = UIAlertController(title: title ?? "",
                                                message: message,
                                                defaultActionButtonTitle: buttonTittle ?? "",
                                                tintColor: .black)
        DispatchQueue.main.async { [weak self] in
            if self?.presentedViewController == nil{
                self?.present(alertController, animated: true, completion: nil)
            }else{
                self?.presentedViewController!.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func backAction() {
        viewModel.back()
    }
    
    @objc func handleKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.bottomConstraint?.constant = 10.0
        } else {
            if #available(iOS 11.0, *) {
                self.bottomConstraint?.constant = (endFrame?.size.height ?? 0.0) - self.view.safeAreaInsets.bottom + 10
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
}

extension BaseViewController {
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
