//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewModel {
    var cells = [IntercomChatTableViewCellViewModel(), AmountSelectTableViewCellViewModel(), CButtonTableViewCellViewModel(),HeaderTableViewCellViewModel(), TopTableViewCellViewModel(),  CompletionProgressTableViewCellViewModel(),
        CompleteDetailsTableViewCellViewModel(), BottomTableViewCellViewModel()] as [TableViewCellViewModelProtocol]
    var sections = [TableSectionViewModel]()

    init() {
        // setup data
        let section = TableSectionViewModel()
        let intercom = IntercomChatTableViewCellViewModel()
        section.rows.append(intercom)
        let amountSelect = AmountSelectTableViewCellViewModel()
        section.rows.append(amountSelect)
        let cashOut = CButtonTableViewCellViewModel()
        section.rows.append(cashOut)
        let header = HeaderTableViewCellViewModel()
        section.rows.append(header)
        let topView = TopTableViewCellViewModel()
        section.rows.append(topView)
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
        let bottom = BottomTableViewCellViewModel()
        section.rows.append(bottom)
        self.sections.append(section)
    }
}
