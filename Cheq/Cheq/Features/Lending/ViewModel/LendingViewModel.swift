//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewModel {
    var cells = [AmountSelectTableViewCellViewModel(), IntercomChatTableViewCellViewModel()] as [TableViewCellViewModelProtocol]
    var sections = [TableSectionViewModel]()

    init() {
        // setup data
        let section = TableSectionViewModel()
        let intercom = IntercomChatTableViewCellViewModel()
        section.rows.append(intercom)
        let amountSelect = AmountSelectTableViewCellViewModel()
        section.rows.append(amountSelect)
        self.sections.append(section)
    }
}
