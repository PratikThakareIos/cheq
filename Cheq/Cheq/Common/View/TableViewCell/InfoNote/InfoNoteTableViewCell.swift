//
//  InfoNoteTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 InfoNoteTableViewCell is simply a tableview cell that represents small gray colored text footnotes
 */
class InfoNoteTableViewCell: CTableViewCell {
    
    /// ContainerView is the holding view, we update containerView for background color and margins
    @IBOutlet weak var containerView: UIView!
    
    /// Info icon image
    @IBOutlet weak var infoIcon: UIImageView!
    
    /// The view that holds the icon image
    @IBOutlet weak var infoIconContainer: UIView!
    
    /// Label of the info note
    @IBOutlet weak var informationNoteLabel: CLabel!
    
    /// Horizontal spacing constraint between label and icon
    @IBOutlet weak var infoIconSpacing: NSLayoutConstraint! 

    /// Called when initialise from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = InfoNoteTableViewCellViewModel()
        setupConfig()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// Call **setupConfig** when viewModel is updated 
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
