//
//  CompletionProgressTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **CompletionProgressTableViewCell**. **CompletionProgressTableViewCell** is a completion progress bar on Lending screen during "Complete Details" stage. However, this UI component is not restricted for this usage, use it for similar where the same UI component is required.
 */
class CompletionProgressTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier matching **xib**
    var identifier: String = "CompletionProgressTableViewCell"
    
    /// supporting different mode for this UI component, **CProgressColorMode** differentiates the color of the progress bar
    var mode: CProgressColorMode = .information
    
    /// title above the progress bar
    var header: String = "Complete"
    
    /// this variable determines the text display how many items is completed
    var completedItem: Int = 0
    
    /// this variable determines how many items needs to be completed in total 
    var totalItem: Int = 0
    
    /// this variable determines the percentage that the progress bar is filled
    var progress: Float = 0.5
}
