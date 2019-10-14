//
//  CButtonTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CButtonTableViewCell: CTableViewCell {

    @IBOutlet weak var button: CButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = CButtonTableViewCellViewModel()
        setupConfig()
    }

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

    @IBAction func clicked(_ sender: Any) {
        LoggingUtil.shared.cPrint("cash out")
        NotificationUtil.shared.notify(UINotificationEvent.buttonClicked.rawValue, key: "clicked", value: self.button.titleLabel?.text ?? "")
    }
    
}
