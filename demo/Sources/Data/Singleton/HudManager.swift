//
//  HudManager.swift
//  everfit
//
//  Created by Gà Nguy Hiểm on 2/13/19.
//  Copyright © 2019 Lexonogy. All rights reserved.
//

import MBProgressHUD
import UIKit

class HudManager: NSObject {
    static fileprivate var manager: HudManager?
    static var shared: HudManager {
        if manager == nil {
            manager = HudManager()
        }
        return manager!
    }
    
    fileprivate var appDelegate: AppDelegate? {
        return AppDelegate.shared
    }
    
    fileprivate var hud: MBProgressHUD?
    
    // MARK: - HUD
    func showHUD(_ isShow: Bool = true, _ isTopView: Bool = true) {
        if let window = appDelegate?.window, isTopView {
            if isShow {
                MBProgressHUD.showAdded(to: window, animated: true)
            } else {
                MBProgressHUD.hide(for: window, animated: true)
            }
        }
    }
    
    func showHUD(for view: UIView, _ isShow: Bool = true) {
        if isShow {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.bezelView.color = .clear
            hud.bezelView.style = .solidColor
            hud.contentColor = .gray
            self.hud = hud
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func hideHUD(for view: UIView) {
        HudManager.shared.showHUD(for: view, false)
        self.hud = nil
    }
    
    func hideHUD() {
        self.showHUD(false)
    }
}
