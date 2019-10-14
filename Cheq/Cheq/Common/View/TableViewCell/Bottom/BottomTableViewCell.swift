//
//  BottomTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BottomTableViewCell: CTableViewCell {

    @IBOutlet weak var bottom: UIView!

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
        self.backgroundColor = .clear
        self.bottom.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.bottom.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        self.bottom.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}
