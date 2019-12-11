//
//  InfoNoteTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 If we have more information notes on our UI, populate **infoNote** enum and reference rawValue from it instead of hardcoding it elsewhere
 */
enum infoNote: String {
    case predictionOnly = "Predictions only - check your bills for details."
}

/**
 viewModel for **InfoNoteTableViewCell**
 */
class InfoNoteTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "InfoNoteTableViewCell"
    
    /// data is simply the String value from infoNote enums
    var data: String = infoNote.predictionOnly.rawValue
    
    /// showIcon determines whether we want to show disclosure icon
    var showIcon: Bool = true
    
    /// text alignment for info notes 
    var textAlignment: NSTextAlignment = .natural
}
