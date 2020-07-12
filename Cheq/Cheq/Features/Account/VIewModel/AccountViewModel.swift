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
    case helpAndSupport = "Help & Support"
    case privacyPolicy = "Privacy Policy" //"Policy"
    case termsAndConditions = "Terms of Use"
    case appSetting = "Settings"
    case logout = "Log out"
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
        spacer.height = 24
        
        section.rows.append(spacer)
        section.rows.append(AvatarTableViewCellViewModel())
        section.rows.append(spacer)
        section.rows.append(spacer)
        
        let fullName = AccountInfoTableViewCellViewModel()
        fullName.showDisclosureIcon = false
        fullName.subHeader = AccountInfo.fullname.rawValue
        fullName.information = "\(firstname) \(lastname)"
        
        section.rows.append(fullName)
        section.rows.append(spacer)
        
        let mobile = AccountInfoTableViewCellViewModel()
        mobile.showDisclosureIcon = false
        mobile.subHeader = AccountInfo.mobile.rawValue
        mobile.information = mb
        section.rows.append(mobile)
        section.rows.append(spacer)
        
        let email = AccountInfoTableViewCellViewModel()
        email.showDisclosureIcon = false
        email.subHeader = AccountInfo.email.rawValue
        email.information = loggedInEmail
        section.rows.append(email)
        section.rows.append(spacer)
        
        
        let spacer32 = SpacerTableViewCellViewModel()
        spacer32.height = 32

        
        let helpAndSupport = LinkTableViewCellViewModel()
        helpAndSupport.header = AccountInfo.helpAndSupport.rawValue
        helpAndSupport.link = .helpAndSupport
        
        section.rows.append(spacer32)
        section.rows.append(helpAndSupport)
        section.rows.append(spacer32)
        
        let privacyPolicy = LinkTableViewCellViewModel()
        privacyPolicy.header = AccountInfo.privacyPolicy.rawValue
        privacyPolicy.link = .privacy
        section.rows.append(privacyPolicy)
        section.rows.append(spacer32)
        
        let termsAndConditions = LinkTableViewCellViewModel()
        termsAndConditions.header = AccountInfo.termsAndConditions.rawValue
        termsAndConditions.link = .toc
        section.rows.append(termsAndConditions)
        section.rows.append(spacer32)
        
//        let appSetting = LinkTableViewCellViewModel()
//        appSetting.header = AccountInfo.appSetting.rawValue
//        appSetting.link = .appSetting
//        section.rows.append(appSetting)
//        section.rows.append(spacer)
        
        let logout = LinkTableViewCellViewModel()
        logout.header = AccountInfo.logout.rawValue
        logout.link = .logout
        logout.linkColor = UIColor(hex: "CE3B49") //AppConfig.shared.activeTheme.errorColor
        logout.showDisclosureIcon = false
        section.rows.append(logout)
        section.rows.append(spacer)
        
//        let version = InfoNoteTableViewCellViewModel()
//        let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
//        version.data = "Version \(ver)"
//        version.showIcon = false
//        version.textAlignment = .center
//        section.rows.append(version)
//        section.rows.append(spacer)
        
        self.sections = [section]
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
}
