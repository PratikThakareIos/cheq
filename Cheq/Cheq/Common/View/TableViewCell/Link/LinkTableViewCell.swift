//
//  LinkTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LinkTableViewCell: CTableViewCell {
    
    @IBOutlet weak var header: CLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = LinkTableViewCellViewModel()
        setupTapOpenLink()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! LinkTableViewCellViewModel
        header.font = AppConfig.shared.activeTheme.mediumBoldFont
        header.textColor = vm.linkColor
        header.text = vm.header
        if vm.showDisclosureIcon {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
    }
    
    func setupTapOpenLink() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func openLink() {
        let vm = self.viewModel as! LinkTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.openLink.rawValue, key: NotificationUserInfoKey.link.rawValue, object: vm.link.rawValue)
    }
}
