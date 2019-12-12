//
//  MessageBubbleTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 MessageBubbleTableViewCell is UI implementation for a message bubble text for notice use. This is UI in Lending screens.
 */
class MessageBubbleTableViewCell: CTableViewCell {

    /// refer to **xib**
    @IBOutlet weak var message: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var notificationIcon: UIImageView!
    
    /// refer to **xib**
    @IBOutlet weak var containerView: UIView!
    
    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = MessageBubbleTableViewCellViewModel()
        self.setupConfig()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// execute setupConfig to update UI after assigning viewModel values 
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as? MessageBubbleTableViewCellViewModel ?? MessageBubbleTableViewCellViewModel()
        self.message.text = vm.messageText
        self.notificationIcon.image = UIImage(named: vm.imageIcon())
        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: AppConfig.shared.activeTheme.lightGrayScaleColor, applyShadow: false)
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor )
    }
    
}
