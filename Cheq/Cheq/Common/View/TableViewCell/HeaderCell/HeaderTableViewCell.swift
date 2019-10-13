//
//  HeaderTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class HeaderTableViewCell: CTableViewCell {

    @IBOutlet weak var headerTitle: CLabel!
    @IBOutlet weak var viewAllButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setupConfig() {
        // customise UI
        self.backgroundColor = .clear
       self.headerTitle.font = AppConfig.shared.activeTheme.mediumFont
    self.viewAllButton.setTitleColor(AppConfig.shared.activeTheme.grayTextColor, for: .normal)
        self.viewAllButton.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
    }

    @IBAction func viewAll(_ sender: Any) {
        LoggingUtil.shared.cPrint("view all")
    }
}
