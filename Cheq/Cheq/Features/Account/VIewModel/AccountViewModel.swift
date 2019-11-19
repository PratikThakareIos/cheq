//
//  AccountViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum AccountInfo: String {
    case fullname = "Full name"
    case email = "Email"
    case mobile = "Mobile"
}

class AccountViewModel: BaseTableVCViewModel {
    override init() {
        super.init()
        self.screenName = .accountInfo
    }
    
    func render() {
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        let firstname = qvm.fieldValue(.firstname)
        let lastname = qvm.fieldValue(.lastname)
        let mb = qvm.fieldValue(.contactDetails)
        let loggedInEmail = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        
        clearSectionIfNeeded()
        let section = TableSectionViewModel()
        let spacer = SpacerTableViewCellViewModel()
        
        section.rows.append(AvatarTableViewCellViewModel())
        section.rows.append(spacer)
        
        let fullName = AccountInfoTableViewCellViewModel()
        fullName.subHeader = AccountInfo.fullname.rawValue
        fullName.information = "\(firstname) \(lastname)"
        section.rows.append(fullName)
        section.rows.append(spacer)
        
        let email = AccountInfoTableViewCellViewModel()
        email.subHeader = AccountInfo.email.rawValue
        email.information = loggedInEmail
        section.rows.append(email)
        section.rows.append(spacer)
        
        let mobile = AccountInfoTableViewCellViewModel()
        mobile.subHeader = AccountInfo.mobile.rawValue
        mobile.information = mb
        section.rows.append(mobile)
        section.rows.append(spacer)
        
        self.sections = [section]
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
