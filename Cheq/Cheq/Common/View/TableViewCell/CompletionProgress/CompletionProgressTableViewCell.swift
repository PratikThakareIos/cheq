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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    override func setupConfig() {
        self.completionTitle.font = AppConfig.shared.activeTheme.mediumFont
        self.completionProgressBar.setProgress(0.5, animated: true)
    }

    
}
