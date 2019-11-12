//
//  TransactionGroupTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class TransactionGroupTableViewCell: CTableViewCell {
    
    @IBOutlet weak var categoryTitle: CLabel!
    @IBOutlet weak var categoryAmount: CLabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var progressView: CProgressView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        self.viewModel = TransactionGroupTableViewCellViewModel()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCategory))
        tapRecognizer.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(tapRecognizer)
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.progressView.mode = .gradientMonetary
        self.progressView.setupConfig()
        let vm = self.viewModel as! TransactionGroupTableViewCellViewModel
        self.categoryTitle.text = vm.data.categoryTitle
        self.categoryAmount.text = FormatterUtil.shared.currencyFormat(vm.data.categoryAmount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: true)
        let code = vm.data.categoryCode ?? CategoryAmountStatResponse.CategoryCode.others
        let iconName = DataHelperUtil.shared.iconFromCategory(code)
        self.categoryIcon.image = UIImage.init(named: iconName)
        let amount = vm.data.categoryAmount ?? 0.0
        let total = vm.data.totalAmount ?? 100.0
        self.progressView.progress = Float(amount / total)
    }
    
    @objc func showCategory() {
        let vm = self.viewModel as! TransactionGroupTableViewCellViewModel
        NotificationUtil.shared.notify(UINotificationEvent.selectedCategoryById.rawValue, key: "id", value: String(vm.data.categoryId ?? 0))
    }
}
