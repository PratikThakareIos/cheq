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
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemTitleStatus: UILabel!
    
    
    /// refer to **xib** for layout
    @IBOutlet weak var itemCaption: UILabel!

    /// refer to **xib** for layout
    @IBOutlet weak var infoLabel: UILabel!

    /// refer to **xib** for layout
    @IBOutlet weak var amountLabel: UILabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var feeLabel: UILabel!
    
    
    @IBOutlet weak var replayEarlyButton: UIButton!

    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    
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
        
        itemTitle.text = historyItemVm.itemTitle
        itemTitleStatus.text = historyItemVm.itemTitleStatus

        infoLabel.text = historyItemVm.info
        infoLabel.isHidden = historyItemVm.info == nil
        
        itemCaption.text = historyItemVm.getFormattedDate()//historyItemVm.itemCaption
        amountLabel.text = historyItemVm.amount
        amountLabel.textColor = (historyItemVm.cashDirection == .debit) ? AppConfig.shared.activeTheme.textColor :  UIColor(hex: "00B662")
        
        feeLabel.font = AppConfig.shared.activeTheme.defaultFont
        feeLabel.text = historyItemVm.fee
        iconImage.image = UIImage(named: historyItemVm.imageIcon())
        
        self.replayEarlyButton.isHidden = !historyItemVm.CanRepayEarly
        self.snoozeButton.isHidden = !historyItemVm.CanDefer
        self.buttonWidthConstraint.constant = historyItemVm.CanRepayEarly ? 105 : 0
        
        self.buttonViewHeightConstraint.constant = (historyItemVm.CanRepayEarly || historyItemVm.CanDefer) ? 40 : 0
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.replayEarlyButton.layer.cornerRadius = 10
        self.replayEarlyButton.clipsToBounds = true
        self.snoozeButton.layer.cornerRadius = 10
        self.snoozeButton.clipsToBounds = true
    }
    
    @IBAction func repayEarlyClciked(_ sender: UIButton) {
        let historyItemVm = self.viewModel as! HistoryItemTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.clickedOnEarlyPay.rawValue, key: NotificationUserInfoKey.loanActivity.rawValue , object: historyItemVm.loanActivity)
    }
    
    
    @IBAction func snooozeClicked(_ sender: UIButton) {
        let historyItemVm = self.viewModel as! HistoryItemTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.clickedOnSnooze.rawValue, key: NotificationUserInfoKey.loanActivity.rawValue , object: historyItemVm.loanActivity)
    }
    
    @IBAction func btnClickedOnCell(_ sender: Any) {
        let historyItemVm = self.viewModel as! HistoryItemTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.clickedOnActivity.rawValue, key: NotificationUserInfoKey.loanActivity.rawValue , object: historyItemVm.loanActivity)
    }
    
}
