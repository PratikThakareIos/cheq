//
//  CompletionProgressTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CompletionProgressTableViewCell is progress bar displayed on **Complete Details** stages on Lending screen
 */
class CompletionProgressTableViewCell: CTableViewCell {

    /// refer to **xib**
    @IBOutlet weak var completionTitle: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var completionProgress: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var completionProgressBar: CProgressView!

    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Initialization code
        self.viewModel = CompletionProgressTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected
        (_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    /// call **setupConfig** to apply UI update after we assigned viewModel 
    override func setupConfig() {
        let vm = self.viewModel as! CompletionProgressTableViewCellViewModel
        self.completionTitle.font = AppConfig.shared.activeTheme.mediumBoldFont
        self.completionTitle.text = vm.header
        self.completionProgress.font = AppConfig.shared.activeTheme.defaultFont
        self.completionProgress.text = String(describing: "\(vm.completedItem) of \(vm.totalItem)")
        self.completionProgressBar.setProgress(vm.progress, animated: true)
        self.completionProgressBar.mode = vm.mode
        self.completionProgressBar.setupConfig()
    }

    
}
