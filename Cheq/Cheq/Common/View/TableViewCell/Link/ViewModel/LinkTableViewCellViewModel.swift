//
//  LinkTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **LinkTableViewCell**
 */
class LinkTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "LinkTableViewCell"
    
    /// AccountInfo header is keep as enum rawValues for easier lookup
    var header: String = AccountInfo.privacyPolicy.rawValue
    
    /// links enums holds all the link urls
    var link: links = .privacy
    
    /// boolean to toggle if we show the disclosure arrow
    var showDisclosureIcon: Bool = true
    
    /// color of the link 
    var linkColor = AppConfig.shared.activeTheme.textColor
}
