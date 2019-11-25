//
//  CollectionViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class UpcomingBillCollectionViewCell: CCollectionViewCell {

    @IBOutlet weak var icon: UIImageView! 
    @IBOutlet weak var merchanLabel: CLabel!
    @IBOutlet weak var remainingTimeLabel: CLabel!
    @IBOutlet weak var amountLabel: CLabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionViewCellHeight: NSLayoutConstraint! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = UpcomingBillCollectionViewCellViewModel()
        setupUI()
    }
    
    override func setupUI() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppConfig.shared.activeTheme.textBackgroundColor
        self.merchanLabel.font = AppConfig.shared.activeTheme.mediumMediumFont
        self.remainingTimeLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.remainingTimeLabel.textColor = AppConfig.shared.activeTheme.lightGrayColor
        self.amountLabel.font = AppConfig.shared.activeTheme.mediumMediumFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
        let vm = self.viewModel as! UpcomingBillCollectionViewCellViewModel
        self.merchanLabel.text = vm.data.merchant
        self.remainingTimeLabel.text = String("in \(vm.data.daysToDueDate ?? -1) days")
        self.amountLabel.text = FormatterUtil.shared.currencyFormat(vm.data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
        
        let categoryCode = DataHelperUtil.shared.categoryAmountStateCode(vm.data.categoryCode ?? GetUpcomingBillResponse.CategoryCode.others)
        let iconName = DataHelperUtil.shared.iconFromCategory(categoryCode, largeIcon: true)
        self.icon.image = UIImage.init(named: iconName)
    }
}
