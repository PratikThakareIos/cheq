//
//  InfoNoteTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum infoNote: String {
    case predictionOnly = "Predictions only - check your bills for details."
}

class InfoNoteTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "InfoNoteTableViewCell"
    var data: String = infoNote.predictionOnly.rawValue
    var showIcon: Bool = true
    var textAlignment: NSTextAlignment = .natural
}
