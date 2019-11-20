//
//  LinkTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LinkTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "LinkTableViewCell"
    var header: String = AccountInfo.privacyPolicy.rawValue
    var link: links = .privacy
    var showDisclosureIcon: Bool = true
    var linkColor = AppConfig.shared.activeTheme.textColor
}
