//
//  AgreementItemTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AgreementItemTableViewCell: CTableViewCell {

    @IBOutlet weak var agreementContentHeight: NSLayoutConstraint! 
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
        // html content
        self.agreementContent.attributedText = vm.message.htmlToAttributedString
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
        if vm.expanded == false {
            vm.expanded = true
            let sizeThatFits = self.agreementContent.sizeThatFits(CGSize(width: self.agreementContent.frame.width, height: CGFloat(MAXFLOAT)))
            self.agreementContentHeight.constant = sizeThatFits.height
            self.readMore.setTitle(vm.readLessTitle, for: .normal)
            
        } else {
            vm.expanded = false
            self.agreementContentHeight.constant = 45
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
            
        }
        self.setNeedsLayout()
        NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: NotificationUserInfoKey.cell.rawValue, object: self)
    }
}
