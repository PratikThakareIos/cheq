//
//  CollectionViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 UpcomingBillCollectionViewCell is subclass of CCollectionViewCell. By subclassing CCollectionViewCell, we can develop different horizontally scrollable components on tableview.
 */
class UpcomingBillCollectionViewCell: CCollectionViewCell {

    /// icon of biller, using category icon for now, but switch to biller icon later
    @IBOutlet weak var icon: UIImageView!
    
    /// merchant name
    @IBOutlet weak var merchanLabel: CLabel!
    
    /// remaining time to pay the upcoming bill
    @IBOutlet weak var remainingTimeLabel: CLabel!
    
    /// upcoming bill amount
    @IBOutlet weak var amountLabel: CLabel!
    
    /// container view of cell, for maintaining background color and margins
    @IBOutlet weak var containerView: UIView!
    
    /// height constraint of collection view cell, in case we want to programmatically update cell height
    @IBOutlet weak var collectionViewCellHeight: NSLayoutConstraint! 
    
    /// In awakeFromNib, viewModel is initialised with default dummy values. After we set the intended values, call **setupUI** method again to keep cell UI updated.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = UpcomingBillCollectionViewCellViewModel()
        setupUI()
    }
    
    /// method to update the appearance of **UpcomingBillCollectionViewCell**
    override func setupUI() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppConfig.shared.activeTheme.textBackgroundColor
        self.merchanLabel.font = AppConfig.shared.activeTheme.mediumMediumFont
        self.remainingTimeLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.remainingTimeLabel.textColor = AppConfig.shared.activeTheme.lightGrayColor
        self.amountLabel.font = AppConfig.shared.activeTheme.mediumMediumFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
        
        /// notice that by default viewModel is **CollectionViewCellViewModelProtocol**, so we have to cast to **UpcomingBillCollectionViewCellViewModel** first in order to read the variables we want from **UpcomingBillCollectionViewCellViewModel**
        let vm = self.viewModel as! UpcomingBillCollectionViewCellViewModel
        self.merchanLabel.text = vm.data.merchant
        self.remainingTimeLabel.text = String("in \(vm.data.daysToDueDate ?? -1) days")
        self.amountLabel.text = FormatterUtil.shared.currencyFormat(vm.data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
        
        let categoryCode = DataHelperUtil.shared.categoryAmountStateCode(vm.data.categoryCode ?? GetUpcomingBillResponse.CategoryCode.others)
        let iconName = DataHelperUtil.shared.iconFromCategory(categoryCode, largeIcon: true)
        self.icon.image = UIImage.init(named: iconName)
    }
}
