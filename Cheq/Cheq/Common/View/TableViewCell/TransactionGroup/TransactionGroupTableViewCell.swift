//
//  TransactionGroupTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionGroupTableViewCell: CTableViewCell {
    
    @IBOutlet weak var categoryTitle: CLabel!
    @IBOutlet weak var categoryAmount: CLabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var progressView: CProgressView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.progressView.mode = .gradientMonetary
        self.progressView.setupConfig()
    }
    
}
