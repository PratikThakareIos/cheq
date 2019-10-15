//
//  TransferCardTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransferCardTableViewCell: CTableViewCell {

    @IBOutlet weak var amountLabel: CLabel!
    @IBOutlet weak var feeLabel: CLabel!
    @IBOutlet weak var transferIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: CLabel!
    @IBOutlet weak var dateString: CLabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = TransferCardTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! TransferCardTableViewCellViewModel
        let bgColor: UIColor = (vm.direction == .debit) ? AppConfig.shared.activeTheme.alternativeColor3 : AppConfig.shared.activeTheme.monetaryColor
        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: bgColor.withAlphaComponent(0.05), applyShadow: false)
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor)
        self.amountLabel.text = vm.transferAmount
        self.amountLabel.font = AppConfig.shared.activeTheme.headerFont
        self.feeLabel.text = vm.feeAmountText
        self.feeLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.feeLabel.textColor = AppConfig.shared.activeTheme.lightestGrayColor
        self.dateString.text = vm.dateString
        let transferImage = (vm.direction == .debit) ? "debit" : "credit"
        self.transferIcon.image = UIImage(named: transferImage)
        self.descriptionLabel.text = vm.descriptionText
    }
}
