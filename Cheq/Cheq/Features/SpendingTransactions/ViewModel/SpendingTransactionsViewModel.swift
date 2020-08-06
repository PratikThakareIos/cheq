//
//  SpendingTransactionsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingTransactionsViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .spendingTransactions
    }
    
    func render(_ transactionsResponse: [DailyTransactionsResponse]) {
        
        let spacer = SpacerTableViewCellViewModel()
        var section = TableSectionViewModel()
        section.rows.append(spacer)

        //categoryMonthlyStats(transactionsResponse.monthAmountStats, section: &section)
        for dailyTransaction: DailyTransactionsResponse in transactionsResponse {
            let header = HeaderTableViewCellViewModel()
            header.showViewAll = false
            
            header.title = self.convertDateFormater(dailyTransaction.date ?? "") ?? "" //dailyTransaction.date ?? ""
            header.titleFont =  UIFont.init(name: FontConstant.SFProTextSemibold, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            
            section.rows.append(header)
            section.rows.append(spacer)
            transactionList(dailyTransaction.transactions ?? [], hideIcon: false,  section: &section)
            section.rows.append(spacer)
        }
        self.sections = [section]
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}

extension SpendingTransactionsViewModel {
    
    func convertDateFormater(_ date: String) -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         
         if let date = dateFormatter.date(from: date) {
             dateFormatter.dateFormat = "EEEE, d MMM"
             return  dateFormatter.string(from: date)
         }
         return nil
     }
}

