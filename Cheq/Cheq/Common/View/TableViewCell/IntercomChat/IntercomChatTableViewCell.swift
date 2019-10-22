//
//  IntercomChatTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class IntercomChatTableViewCell: CTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = IntercomChatTableViewCellViewModel()
        self.setupConfig()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func intercom() {
        LoggingUtil.shared.cPrint("present intercom")
        NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
    }

    override func setupConfig() {
        self.backgroundColor = .clear
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}
