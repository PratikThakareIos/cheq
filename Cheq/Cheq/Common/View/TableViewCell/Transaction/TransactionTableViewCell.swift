//
//  TransactionTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: UIView! 
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var transactionTitle: CLabel!
    @IBOutlet weak var transactionDate: CLabel!
    @IBOutlet weak var transactionAmount: CLabel!
    @IBOutlet weak var iconImageContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = TransactionTableViewCellViewModel()
        setupTapEvent()
        setupConfig()
    }
    
    func setupTapEvent() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTransaction))
        tapRecognizer.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(tapRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        let vm = self.viewModel as! TransactionTableViewCellViewModel
        let code = DataHelperUtil.shared.categoryAmountStateCodeFromTransaction(vm.data.categoryCode ?? SlimTransactionResponse.CategoryCode.others)
        let imageIcon = DataHelperUtil.shared.iconFromCategory(code, largeIcon: true)
        self.iconImage.image = UIImage.init(named: imageIcon)
        self.iconImageContainer.isHidden = vm.hideIcon
        self.transactionTitle.text = vm.data._description
        self.transactionAmount.text = FormatterUtil.shared.currencyFormat(vm.data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
        self.transactionDate.text = vm.data.date
        self.transactionDate.font = AppConfig.shared.activeTheme.defaultFont
        self.transactionDate.textColor = AppConfig.shared.activeTheme.lightGrayColor
    }
    
    @objc func showTransaction() {
        NotificationUtil.shared.notify(UINotificationEvent.showTransaction.rawValue, key: NotificationUserInfoKey.transaction.rawValue, object: self)
    }
}
