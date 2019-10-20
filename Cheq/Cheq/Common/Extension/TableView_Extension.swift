//
//  TableView_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PullToRefreshKit

extension UITableView {
    func reloadWithoutScroll() {
        let contentOffset = self.contentOffset
        self.beginUpdates()
        self.endUpdates()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
    
    func addPullToRefreshAction(_ action: @escaping ()->Void) {
        guard let superview = self.superview else { return }
        let header = DefaultRefreshHeader.header()
        header.imageView.image = UIImage(named: "next-arrow-purple")
        header.textLabel.font = AppConfig.shared.activeTheme.defaultFont
        header.textLabel.textColor = AppConfig.shared.activeTheme.primaryColor
        header.setText("", mode: .refreshSuccess)
        header.setText("", mode: .refreshing)
        header.setText("", mode: .refreshFailure)
        header.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.configRefreshHeader(with: header as UIView & RefreshableHeader, container: superview, action: {
            self.switchRefreshHeader(to: .normal(.success, AppConfig.shared.activeTheme.quickAnimationDuration))
            action()
        })
    }
}
