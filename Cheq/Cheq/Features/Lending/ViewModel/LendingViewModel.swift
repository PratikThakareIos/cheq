//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewModel {
    var cells = [
        IntercomChatTableViewCellViewModel(),
        AmountSelectTableViewCellViewModel(),
        CButtonTableViewCellViewModel(),
        TransferCardTableViewCellViewModel(),
        AgreementItemTableViewCellViewModel(),
        HeaderTableViewCellViewModel(),
        HistoryItemTableViewCellViewModel(),
        TopTableViewCellViewModel(),
        CompletionProgressTableViewCellViewModel(),
        CompleteDetailsTableViewCellViewModel(),
        BottomTableViewCellViewModel()
    ] as [TableViewCellViewModelProtocol]
    var sections = [TableSectionViewModel]()

    init() {
        // setup data
        let section = TableSectionViewModel()
        let intercom = IntercomChatTableViewCellViewModel()
        section.rows.append(intercom)
        let amountSelect = AmountSelectTableViewCellViewModel()
        section.rows.append(amountSelect)
        let cashOut = CButtonTableViewCellViewModel()
        cashOut.icon = "speedy"
        section.rows.append(cashOut)
        let transferCardCredit = TransferCardTableViewCellViewModel()
        transferCardCredit.direction = .credit
        section.rows.append(transferCardCredit)
        let transferCardDebit = TransferCardTableViewCellViewModel()
        transferCardDebit.direction = .debit
        section.rows.append(transferCardDebit)
        let loanAgreement = AgreementItemTableViewCellViewModel()
        section.rows.append(loanAgreement)
        let header = HeaderTableViewCellViewModel()
        section.rows.append(header)
        let historyItem = HistoryItemTableViewCellViewModel()
        historyItem.cashDirection = .credit
        section.rows.append(historyItem)
        let historyItem2 = HistoryItemTableViewCellViewModel()
        historyItem2.cashDirection = .debit
        section.rows.append(historyItem2)
        let topView = TopTableViewCellViewModel()
        section.rows.append(topView)
        let completionProgress = CompletionProgressTableViewCellViewModel()
        completionProgress.mode = .monetary
        section.rows.append(completionProgress)
        let completeWorkDetails = CompleteDetailsTableViewCellViewModel()
        completeWorkDetails.type = .workDetails
        completeWorkDetails.expanded = true
        section.rows.append(completeWorkDetails)
        let completeBankDetails = CompleteDetailsTableViewCellViewModel()
        completeBankDetails.completionState = .inactive
        completeBankDetails.type = .bankDetils
        completeBankDetails.expanded = false
        section.rows.append(completeBankDetails)
        let verifyYourDetails = CompleteDetailsTableViewCellViewModel()
        verifyYourDetails.completionState = .done
        verifyYourDetails.type = .verifyYourDetails
        verifyYourDetails.expanded = false
        section.rows.append(verifyYourDetails)
        let bottom = BottomTableViewCellViewModel()
        section.rows.append(bottom)
        self.sections.append(section)
    }
}
