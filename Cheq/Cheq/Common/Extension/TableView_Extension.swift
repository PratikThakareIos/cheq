//
//  TableView_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PullToRefreshKit

/**
 Extension methods of UITableView to facilitate reuse of common logics across UI
 */
extension UITableView {
    
    /// this method is used when we want to reload tableView without the table scrolling back the top after refreshed
    func reloadWithoutScroll() {
        let contentOffset = self.contentOffset
        self.beginUpdates()
        self.endUpdates()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
    
    /// Call this method when we want the UITableView to have a **Pull To Refresh** mechanism. The method will add pull to refresh UI to the table view. 
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
