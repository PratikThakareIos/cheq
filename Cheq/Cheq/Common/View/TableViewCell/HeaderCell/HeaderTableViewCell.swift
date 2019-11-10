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
        self.viewModel = HeaderTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setupConfig() {
        // customise UI
        let vm = self.viewModel as! HeaderTableViewCellViewModel
        self.backgroundColor = .clear
        self.headerTitle.font = AppConfig.shared.activeTheme.mediumFont
        self.headerTitle.text = vm.title
        self.viewAllButton.setTitleColor(AppConfig.shared.activeTheme.lightGrayColor, for: .normal)
        self.viewAllButton.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        self.viewAllButton.isHidden = !vm.showViewAll
        self.tag = vm.tag
    }

    @IBAction func viewAll(_ sender: Any) {
        LoggingUtil.shared.cPrint("view all")
        NotificationUtil.shared.notify(UINotificationEvent.viewAll.rawValue, key: "viewAll", object: self)
    }
}
