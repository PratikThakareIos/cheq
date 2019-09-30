//
//  CMultipleChoiceWithCaptionCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CMultipleChoiceWithCaptionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            self.containerView.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
        } else {
            self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        }
    }

    func setupConfig() {
        self.titleLabel.font = AppConfig.shared.activeTheme.headerFont
        self.captionLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.backgroundColor = .white
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }
}
