//
//  AccountInfoTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AccountInfoTableViewCell: CTableViewCell {
    
    @IBOutlet weak var subHeader: CLabel!
    @IBOutlet weak var information: CLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = AccountInfoTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear 
        subHeader.textColor = AppConfig.shared.activeTheme.lightestGrayColor
        information.font = AppConfig.shared.activeTheme.mediumBoldFont
        information.textColor = AppConfig.shared.activeTheme.textColor
        let vm = self.viewModel as! AccountInfoTableViewCellViewModel
        subHeader.text = vm.subHeader
        information.text = vm.information
    }
    
}
