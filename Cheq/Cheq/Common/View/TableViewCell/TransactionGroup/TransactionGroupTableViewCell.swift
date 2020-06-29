//
//  TransactionGroupTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 TransactionGroupTableViewCell is for representing the transaction group data on Spending screens
 */
class TransactionGroupTableViewCell: CTableViewCell {
    
    /// refer to **xib** layout
    @IBOutlet weak var categoryTitle: CLabel!
    
    /// refer to **xib** layout
    @IBOutlet weak var categoryAmount: CLabel!
    
    /// refer to **xib** layout
    @IBOutlet weak var categoryIcon: UIImageView!
    
    /// refer to **xib** layout
    @IBOutlet weak var progressView: CProgressView!
    
    /// refer to **xib** layout
    @IBOutlet weak var containerView: UIView!
    
    /// refer to **xib** layout
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        self.viewModel = TransactionGroupTableViewCellViewModel()
        setupTapEvent()
        setupConfig()
    }
    
    /// calls **showCategory** when cell containerView is tapped
    func setupTapEvent() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCategory))
        tapRecognizer.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(tapRecognizer)
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// call setupConfig to update UI after updated viewModel
    override func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        

       
        let vm = self.viewModel as! TransactionGroupTableViewCellViewModel
        self.categoryTitle.text = vm.data.categoryTitle
        self.categoryTitle.font = AppConfig.shared.activeTheme.mediumMediumFont
        

        var amountStr = FormatterUtil.shared.currencyFormatWithComma(vm.data.categoryAmount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: true)
        amountStr = amountStr.replacingOccurrences(of: "-", with: "")
        self.categoryAmount.text = amountStr
        
        self.categoryAmount.font = AppConfig.shared.activeTheme.mediumMediumFont
        let code = vm.data.categoryCode ?? CategoryAmountStatResponse.CategoryCode.others
        let iconName = DataHelperUtil.shared.iconFromCategory(code, largeIcon: true)
        self.categoryIcon.image = UIImage.init(named: iconName)
        let amount = vm.data.categoryAmount ?? 0.0
        let total = vm.data.totalAmount ?? 0.0
        
        self.progressView.mode = .gradientMoneySpent
        self.progressView.setupConfig()
        self.progressView.progress = Float(amount / total)
    }
    
    /// showCategory sends notification to **UINotificationEvent.selectedCategoryById** instead of directly triggering the action to show category transactions 
    @objc func showCategory() {
        let vm = self.viewModel as! TransactionGroupTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.selectedCategoryById.rawValue, key: NotificationUserInfoKey.category.rawValue, object: vm.data)
    }
}
