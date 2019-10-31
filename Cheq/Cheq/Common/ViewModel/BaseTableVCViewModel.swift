//
//  BaseTableVCViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BaseTableVCViewModel {
    var screenName: ScreenName = .unknown
    var sections = [TableSectionViewModel]()
    
    @objc func load(_ complete: @escaping () -> Void) { complete() }
    
    func addSection(_ section: TableSectionViewModel) {
        self.sections.append(section)
    }
    
    func insertSection(_ section: TableSectionViewModel, index: Int) {
        self.sections.insert(section, at: index)
    }
}
