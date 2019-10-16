//
//  CompletionProgressTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CompletionProgressTableViewCell: CTableViewCell {

    @IBOutlet weak var completionTitle: CLabel!
    @IBOutlet weak var completionProgress: CLabel!
    @IBOutlet weak var completionProgressBar: CProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = CompletionProgressTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    override func setupConfig() {
        let vm = self.viewModel as! CompletionProgressTableViewCellViewModel
        self.completionTitle.font = AppConfig.shared.activeTheme.mediumFont
        self.completionTitle.text = vm.header
        self.completionProgress.font = AppConfig.shared.activeTheme.defaultFont
        self.completionProgress.text = String(describing: "\(vm.completedItem) of \(vm.totalItem)")
        self.completionProgressBar.setProgress(0.5, animated: true)
        self.completionProgressBar.mode = vm.mode
        self.completionProgressBar.setupConfig()
    }

    
}
