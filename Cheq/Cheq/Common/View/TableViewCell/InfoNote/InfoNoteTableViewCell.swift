//
//  InfoNoteTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class InfoNoteTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var infoIconContainer: UIView!
    @IBOutlet weak var informationNoteLabel: CLabel!
    @IBOutlet weak var infoIconSpacing: NSLayoutConstraint! 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = InfoNoteTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .clear 
        informationNoteLabel.font = AppConfig.shared.activeTheme.defaultFont
        informationNoteLabel.textColor = AppConfig.shared.activeTheme.lightGrayColor
        infoIconSpacing.constant = CGFloat(AppConfig.shared.activeTheme.xxlPadding)
        let vm = self.viewModel as! InfoNoteTableViewCellViewModel
        informationNoteLabel.textAlignment = vm.textAlignment
        self.infoIconContainer.isHidden = !vm.showIcon
        self.informationNoteLabel.text = vm.data
    }
}
