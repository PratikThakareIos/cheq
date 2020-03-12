//
//  PreviewLoanViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class PreviewLoanViewModel: BaseTableVCViewModel {
}

extension PreviewLoanViewModel {
    func addTransferToCard (_ loanPreview: GetLoanPreviewResponse, section: inout TableSectionViewModel) {
        
        let card = TransferCardTableViewCellViewModel()
        card.direction = .credit
        card.dateString = loanPreview.cashoutDate ?? ""
        card.feeAmountText = ""
        let amount = Double(loanPreview.amount ?? 0.0)
        card.transferAmount = "$\(amount)"
        section.rows.append(card)
        
    }
    
    func addRepaymemtCard (_ loanPreview: GetLoanPreviewResponse, section: inout TableSectionViewModel) {
        
        let card = TransferCardTableViewCellViewModel()
        card.direction = .debit
        card.dateString = loanPreview.repaymentDate ?? ""
        if let fee = loanPreview.fee {
            card.feeAmountText = "+ $\(fee) fee"
        } else {
            card.feeAmountText = ""
        }
        
        let amount = Double(loanPreview.amount ?? 0.0)
        card.transferAmount = "$\(amount)"
        section.rows.append(card)
    }
    
    func addLoanAgreementCard (_ loanPreview: GetLoanPreviewResponse, section: inout TableSectionViewModel) {
        
        let card = AgreementItemTableViewCellViewModel()
        card.expanded = false
        card.message = loanPreview.loanAgreement ?? ""
        card.title = "Terms & conditions"
        section.rows.append(card)
    }
    
    func addDirectDebitAgreementCard (_ loanPreview: GetLoanPreviewResponse, section: inout TableSectionViewModel) {
        
        let card = AgreementItemTableViewCellViewModel()
        card.expanded = false
        card.message = loanPreview.directDebitAgreement ?? ""
        card.title = "Direct debit agreement"
        section.rows.append(card)
        
    }
}
