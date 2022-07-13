//
//  UIScrollView+Extension.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
