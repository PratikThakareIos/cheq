//
//  AgreementItemTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AgreementItemTableViewCell: CTableViewCell {

    @IBOutlet weak var agreementTitle: CLabel!
    @IBOutlet weak var agreementContent: CLabel!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = AgreementItemTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
        self.agreementTitle.text = vm.title
        self.agreementTitle.font = AppConfig.shared.activeTheme.mediumFont
        self.agreementContent.text = vm.message
        if vm.expanded {
            self.readMore.setTitle(vm.readLessTitle, for: .normal)
        } else {
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
        }
        self.readMore.setTitleColor(AppConfig.shared.activeTheme.linksColor, for: .normal)
        self.readMore.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor)
    }
    
    @IBAction func readMore(_ sender: Any) {
        LoggingUtil.shared.cPrint("Read more")
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
        if vm.expanded == true {
            vm.expanded = false
            self.agreementContent.numberOfLines = 2
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
            
        } else {
            vm.expanded = true
            self.agreementContent.numberOfLines = 0
            self.readMore.setTitle(vm.readLessTitle, for: .normal)
            
        }
        self.readMore.setNeedsDisplay()
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: "cell", value: self)
    }
}
