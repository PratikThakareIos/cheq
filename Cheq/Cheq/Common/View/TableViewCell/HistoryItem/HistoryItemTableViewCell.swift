//
//  HistoryItemTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 HistoryItemTableViewCell is table view cell showing historical transactions on Lending screen
 */
class HistoryItemTableViewCell: CTableViewCell {
    
    /// refer to **xib** for layout
    @IBOutlet weak var iconImage: UIImageView!
    
    /// refer to **xib** for layout
    @IBOutlet weak var itemTitle: CLabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var itemCaption: CLabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var amountLabel: CLabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var feeLabel: CLabel!
    
    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        /// ViewModel initialization code
        self.viewModel = HistoryItemTableViewCellViewModel()
        setupConfig()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// call **setupConfig** whenever we updated viewModel 
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
