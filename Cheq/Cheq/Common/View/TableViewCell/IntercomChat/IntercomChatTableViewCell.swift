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
        self.setupConfig()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setupConfig() {
        self.viewModel = IntercomChatTableViewCellViewModel()
        self.backgroundColor = .clear 
    }

    @IBAction func intercom() {
        LoggingUtil.shared.cPrint("present intercom")
    }
    
}
