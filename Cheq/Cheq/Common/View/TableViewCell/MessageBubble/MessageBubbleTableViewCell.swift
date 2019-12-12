//
//  MessageBubbleTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class MessageBubbleTableViewCell: CTableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
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
    
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as? MessageBubbleTableViewCellViewModel ?? MessageBubbleTableViewCellViewModel()
        self.message.text = vm.messageText
        self.notificationIcon.image = UIImage(named: vm.imageIcon())
        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: AppConfig.shared.activeTheme.lightGrayScaleColor, applyShadow: false)
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor )
    }
    
}
