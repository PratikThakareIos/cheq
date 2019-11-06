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
        let gradientSet = AppConfig.shared.activeTheme.gradientSet4
//        ViewUtil.shared.applyViewGradient(self.contentView, startingColor: gradientSet.first ?? .white, endColor: gradientSet.last ?? .white)
    }
    
}
