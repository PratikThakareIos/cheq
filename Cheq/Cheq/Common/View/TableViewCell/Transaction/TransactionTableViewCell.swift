//
//  TransactionTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 TransactionTableViewCell is use for transaction representation on Spending screens
 */
class TransactionTableViewCell: CTableViewCell {
    
    /// container view of contents
    @IBOutlet weak var containerView: UIView!
    
    /// refer to **xib** layout
    @IBOutlet weak var iconImage: UIImageView!
    
    /// refer to **xib** layout
    @IBOutlet weak var transactionTitle: CLabel!
    
    /// refer to **xib** layout
    @IBOutlet weak var transactionDate: CLabel!
    
    /// refer to **xib** layout
    @IBOutlet weak var transactionAmount: CLabel!
    
    /// refer to **xib** layout
    @IBOutlet weak var iconImageContainer: UIView!
    
    /// width constraint for **iconImageContainer**
    @IBOutlet weak var iconImageContainerWidth: NSLayoutConstraint! 

    /// called when initialize from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = TransactionTableViewCellViewModel()
        setupTapEvent()
        setupConfig()
    }
    
    /// **showTransaction** method is called when containerView is tapped
    func setupTapEvent() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTransaction))
        tapRecognizer.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(tapRecognizer)
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// setupConfig updates the UI accordingly to the viewModel
    override func setupConfig() {
        let vm = self.viewModel as! TransactionTableViewCellViewModel
        let code = DataHelperUtil.shared.categoryAmountStateCodeFromTransaction(vm.data.categoryCode ?? SlimTransactionResponse.CategoryCode.others)
        let imageIcon = DataHelperUtil.shared.iconFromCategory(code, largeIcon: true)
        self.iconImage.image = UIImage.init(named: imageIcon)
        self.iconImageContainer.isHidden = vm.hideIcon
        self.iconImageContainerWidth.constant = vm.hideIcon ? 0 : AppConfig.shared.activeTheme.xlPadding
        self.transactionTitle.text = vm.data._description
        self.transactionTitle.font = AppConfig.shared.activeTheme.mediumMediumFont
        
        
        var strAmount = FormatterUtil.shared.currencyFormatWithComma(vm.data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
        
        if (strAmount.contains("-")){
            strAmount = strAmount.replacingOccurrences(of: "-", with: "")
            strAmount = "-" + strAmount
            self.transactionAmount.textColor = AppConfig.shared.activeTheme.textColor
        }else{
            self.transactionAmount.textColor = UIColor(hex: "00B662")
        }
        
        self.transactionAmount.text = strAmount
        self.transactionAmount.font = AppConfig.shared.activeTheme.mediumMediumFont
        
        self.transactionDate.text = vm.data.date
        self.transactionDate.font = AppConfig.shared.activeTheme.defaultMediumFont
        self.transactionDate.textColor = AppConfig.shared.activeTheme.lightGrayColor
        self.setNeedsUpdateConstraints()
    }
    
    /// showTransaction method doesn't directly presents the transaction details modal, it sends out the notification for
    @objc func showTransaction() {
        NotificationUtil.shared.notify(UINotificationEvent.showTransaction.rawValue, key: NotificationUserInfoKey.transaction.rawValue, object: self)
    }
}
