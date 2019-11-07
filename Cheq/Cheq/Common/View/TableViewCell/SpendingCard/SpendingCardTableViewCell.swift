//
//  SpendingCardTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingCardTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBarView: CProgressView!
    @IBOutlet weak var headerLabel: CLabel!
    @IBOutlet weak var countDownLabel: CLabel!
    @IBOutlet weak var subHeaderLabel: CLabel! 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight*2)
        }
    }
    
    override func setupConfig() {
        headerLabel.font = AppConfig.shared.activeTheme.extraLargeFont
        headerLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        subHeaderLabel.font = AppConfig.shared.activeTheme.mediumFont
        subHeaderLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        countDownLabel.font = AppConfig.shared.activeTheme.headerFont
        countDownLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        
        let gradientSet = AppConfig.shared.activeTheme.gradientSet4
//        ViewUtil.shared.applyViewGradient(self.contentView, startingColor: gradientSet.first ?? .white, endColor: gradientSet.last ?? .white)
        self.containerView.backgroundColor = .red
        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: .red, applyShadow: true)
        
    }
    
}
