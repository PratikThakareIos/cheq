//
//  HistoryItemTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **HistoryItemTableViewCell**. This is the table view cell for showing historic transactions on Lending screen. But we are not limited to use it only on Lending screen.
 */
class HistoryItemTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    var loanActivity: LoanActivity?
    
    /// reuse identifier
    var identifier: String = "HistoryItemTableViewCell"
    
    /// enum to represent the direction of cash
    var cashDirection: CashDirection = .debit

    /// info shown extra transaction info, for example settlementTimingInfo for pending repayment
    var info: String?

    /// amount is in String because we use it for label value
    var amount: String = "$200"
    
    /// itemItem is description header, this is driven by **cashDirection** variable
    var itemTitle: String = "Cash out"
    var itemTitleStatus : String = ""
    
    /// caption text for further details about the history item, can be Date string
    var itemCaption: String = "Today"
    
    /// fee value for fee label on table view cell
    var fee: String = "fee $10"
    
    /// for early pay and snooze - sachin
    var CanDefer = false
    var CanRepayEarly = false
    
//    /// image name of **HistoryItemTableViewCell** depending on **cashDirection**
//    func imageIcon()->String {
//        return self.cashDirection == .debit ? "debit" : "credit"
//    }
    
    func imageIcon() -> String {
        guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
        switch status {
            case .credited:
                return "icon-withdrawal"
            case .debited:
                return "icon-repayment"
            case .failed:
                return "icon-repaymentFailed"
            case .unprocessed, .pending, .unsuccessfulAttempt:
                return "icon-pendingRepayment"
        }
    }
    

    func getFormattedDate()->String{
        if let strDate = self.convertDateFormater(self.itemCaption){
            return strDate
        }
        return itemCaption
    }
    
    func convertDateFormater(_ date: String) -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         
         if let date = dateFormatter.date(from: date) {
             dateFormatter.dateFormat = "E, d MMM"
             return  dateFormatter.string(from: date)
         }
         return nil
     }
}
