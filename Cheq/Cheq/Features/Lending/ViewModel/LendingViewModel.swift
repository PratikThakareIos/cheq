//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewModel {
    var cells = [IntercomChatTableViewCellViewModel(), AmountSelectTableViewCellViewModel(), CompletionProgressTableViewCellViewModel(),
        CompleteDetailsTableViewCellViewModel()] as [TableViewCellViewModelProtocol]
    var sections = [TableSectionViewModel]()

    init() {
        // setup data
        let section = TableSectionViewModel()
        let intercom = IntercomChatTableViewCellViewModel()
        section.rows.append(intercom)
        let amountSelect = AmountSelectTableViewCellViewModel()
        section.rows.append(amountSelect)
        let completionProgress = CompletionProgressTableViewCellViewModel()
        section.rows.append(completionProgress)
        let completeWorkDetails = CompleteDetailsTableViewCellViewModel()
        completeWorkDetails.type = .workDetails
        completeWorkDetails.expanded = true
        section.rows.append(completeWorkDetails)
        let completeBankDetails = CompleteDetailsTableViewCellViewModel()
        completeBankDetails.type = .bankDetils
        completeBankDetails.expanded = false
        section.rows.append(completeBankDetails)
        let verifyYourDetails = CompleteDetailsTableViewCellViewModel()
        verifyYourDetails.type = .verifyYourDetails
        verifyYourDetails.expanded = false
        section.rows.append(verifyYourDetails)
        self.sections.append(section)
    }
}
