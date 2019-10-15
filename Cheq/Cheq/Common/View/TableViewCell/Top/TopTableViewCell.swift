//
//  TopTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TopTableViewCell: CTableViewCell {

    @IBOutlet weak var topView: UIView!

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
        self.topView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.topView.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        self.topView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
