//
//  CompletionProgressTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 */
class CompletionProgressTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "CompletionProgressTableViewCell"
    var mode: CProgressColorMode = .information
    var header: String = "Complete"
    var completedItem: Int = 0
    var totalItem: Int = 0
    var progress: Float = 0.5
}
