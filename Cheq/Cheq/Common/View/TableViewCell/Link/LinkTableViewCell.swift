//
//  LinkTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 LinkTableViewCell is use for displaying tappable link cells.This cell is used in **AccountViewController** but not restricted for other use.
 */
class LinkTableViewCell: CTableViewCell {
    
    /// header of the link, refer to **xib** for layout
    @IBOutlet weak var header: CLabel!

    /// method call from **xib** initialisation
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = LinkTableViewCellViewModel()
        setupTapOpenLink()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// stylize and apply viewModel data
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! LinkTableViewCellViewModel
        header.font = AppConfig.shared.activeTheme.mediumBoldFont
        header.textColor = vm.linkColor
        header.text = vm.header
        
        /// use the default **disclosureIndicator** if **showDisclosureIcon** is true
        if vm.showDisclosureIcon {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
    }
    
    /// this method sets up tap gesture for cell to call **openLink** when it's tapped once
    func setupTapOpenLink() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    /// OpenLink method doesn't directly open a link, it sends a **UINotificationEvent** through **NotificationUtil**, so when subclass of **CTableViewController** receives this notification, its event handler will open the corresponding link accordingly. This decouples the binding between our cell implementation to a specific viewController allowing for better re-usability. 
    @objc func openLink() {
        let vm = self.viewModel as! LinkTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.openLink.rawValue, key: NotificationUserInfoKey.link.rawValue, object: vm.link.rawValue)
    }
}
