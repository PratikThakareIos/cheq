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
        self.agreementContent.text = vm.message
        self.readMore.setTitle(vm.readMoreTitle, for: .normal)
        self.readMore.setTitleColor(AppConfig.shared.activeTheme.linksColor, for: .normal)
        self.readMore.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: UIColor(hex: "E0E0E0"))
        self.agreementContent.numberOfLines = 2
    }
    
    @IBAction func readMore(_ sender: Any) {
        LoggingUtil.shared.cPrint("Read more")
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
        if self.agreementContent.numberOfLines == 2 {
            self.agreementContent.numberOfLines = 0
            self.readMore.setTitle(vm.readLessTitle, for: .normal)
            let size = self.agreementContent.sizeThatFits(CGSize(width: self.agreementContent.frame.size.width, height: 10000.0))
            agreementContentHeight.constant = size.height
        } else {
            self.agreementContent.numberOfLines = 2
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
            let size = self.agreementContent.sizeThatFits(CGSize(width: self.agreementContent.frame.size.width, height: 10000.0))
            agreementContentHeight.constant = size.height
        }
        
        self.layoutIfNeeded()
    }
    
}
