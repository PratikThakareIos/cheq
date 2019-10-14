//
//  TableView_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadWithoutScroll() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
}
