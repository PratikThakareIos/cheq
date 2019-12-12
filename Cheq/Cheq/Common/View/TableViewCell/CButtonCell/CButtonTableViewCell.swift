//
//  CButtonTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CButtonTableViewCell is for implementing cashout button based on table view cell. The Cashout button is on Lending screen, but this cell class can be used for anything similar.
 */
class CButtonTableViewCell: CTableViewCell {

    /// the button embeded inside table view cell
    @IBOutlet weak var button: CButton!

    /// called when init by **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = CButtonTableViewCellViewModel()
        setupConfig()
    }

    /// Call **setupConfig** after viewModel is updated
    override func setupConfig() {
        self.backgroundColor = .clear
        let buttonVm = self.viewModel as! CButtonTableViewCellViewModel
        self.button.setTitle(buttonVm.title, for: .normal)
        self.button.setTitleColor(AppConfig.shared.activeTheme.altTextColor, for: .normal)
        self.button.setImage(UIImage(named: buttonVm.icon), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// when button is pressed, **UINotificationEvent.buttonClicked** is sent so that the handling will proceed with their logic, whatever happens is decoupled from the **CButtonTableViewCell** 
    @IBAction func clicked(_ sender: Any) {
        LoggingUtil.shared.cPrint("cash out")
        NotificationUtil.shared.notify(UINotificationEvent.buttonClicked.rawValue, key: NotificationUserInfoKey.button.rawValue, object: self)
    }
    
}
