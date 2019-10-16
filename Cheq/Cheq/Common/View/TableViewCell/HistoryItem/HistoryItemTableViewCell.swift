//
//  HistoryItemTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit



class HistoryItemTableViewCell: CTableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var itemTitle: CLabel!
    @IBOutlet weak var itemCaption: CLabel!
    @IBOutlet weak var amountLabel: CLabel!
    @IBOutlet weak var feeLabel: CLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = HistoryItemTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        let historyItemVm = self.viewModel as! HistoryItemTableViewCellViewModel
        self.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        itemTitle.font = AppConfig.shared.activeTheme.mediumFont
        itemTitle.text = historyItemVm.itemTitle
        itemCaption.font = AppConfig.shared.activeTheme.defaultFont
        itemCaption.text = historyItemVm.itemCaption
        amountLabel.font = AppConfig.shared.activeTheme.mediumFont
        amountLabel.text = historyItemVm.amount
        amountLabel.textColor = (historyItemVm.cashDirection == .debit) ? AppConfig.shared.activeTheme.textColor : AppConfig.shared.activeTheme.monetaryColor
        feeLabel.font = AppConfig.shared.activeTheme.defaultFont
        feeLabel.text = historyItemVm.fee
        iconImage.image = UIImage(named: historyItemVm.imageIcon())
    }
    
}
