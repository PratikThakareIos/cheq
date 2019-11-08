//
//  CollectionViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class UpcomingBillCollectionViewCell: CCollectionViewCell {

    @IBOutlet weak var icon: UIImageView! 
    @IBOutlet weak var merchanLabel: CLabel!
    @IBOutlet weak var remainingTimeLabel: CLabel!
    @IBOutlet weak var amountLabel: CLabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = UpcomingBillCollectionViewCellViewModel()
        setupUI()
    }
    
    override func setupUI() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppConfig.shared.activeTheme.textBackgroundColor
        self.merchanLabel.font = AppConfig.shared.activeTheme.mediumFont
        self.remainingTimeLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.remainingTimeLabel.textColor = AppConfig.shared.activeTheme.mediumGrayColor
        self.amountLabel.font = AppConfig.shared.activeTheme.mediumFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
    }
}
