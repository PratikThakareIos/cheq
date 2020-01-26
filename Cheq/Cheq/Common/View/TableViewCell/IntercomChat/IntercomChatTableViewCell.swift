//
//  IntercomChatTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
IntercomChatTableViewCell is the little chat icon that opens up **Intercom** viewController
 */
class IntercomChatTableViewCell: CTableViewCell {

    /// method executed when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = IntercomChatTableViewCellViewModel()
        self.setupConfig()

    }

    /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected
        (_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// When the intercom chat bubble icon is pressed, a notification is sent which will trigger the event handler to open **Intercom** viewController, but this is decoupled from the tableview cell. So the tableview cell doesn't take care of the integration with **Intercom** sdk, but only have the duty to notify for such an event. This makes the **IntercomChatTableViewCell** robust to be re-use elsewhere.
    @IBAction func intercom() {
        LoggingUtil.shared.cPrint("present intercom")
        NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
    }

    /// Method to setup UI, because viewModel is not containing any specific data, this method is not reading from viewModel
    override func setupConfig() {
        self.backgroundColor = .clear
    }
    
    /// Definiing the intrinsic of the tableview cell. Alternatively use autolayout to define the intrinsic height, then this override variable is not needed 
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}
