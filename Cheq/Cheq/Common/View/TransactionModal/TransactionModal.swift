//
//  TransactionModalView.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftEntryKit

class TransactionModal: UIView {
    
    var viewModel = TransactionModalViewModel()
    @IBOutlet weak var categoryIcon: UIView!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var transactionDescriptionLabel: CLabel!
    @IBOutlet weak var transactionDateLabel: CLabel!
    @IBOutlet weak var transactionAmountLabel: CLabel!
    @IBOutlet weak var categoryTitleLabel: CLabel!
    @IBOutlet weak var categoryTitleImageIconView: UIImageView!
    @IBOutlet weak var financialInstitutionLabel: CLabel!
    @IBOutlet weak var financialInstitutionImageIconView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        setupTapToDismiss()
        setupUI()
    }
    
    func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func setupUI() {
        LoggingUtil.shared.cPrint("TransactionModal setupUI")
        ViewUtil.shared.circularMask(&categoryIcon, radiusBy: .width)
        var financialIcon = financialInstitutionImageIconView as UIView
        ViewUtil.shared.circularMask(&financialIcon, radiusBy: .height)
        AppConfig.shared.activeTheme.cardStyling(contentContainer, addBorder: false)
        self.categoryIcon.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.contentContainer.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        let code = DataHelperUtil.shared.categoryAmountStateCodeFromTransaction(self.viewModel.data.categoryCode ?? SlimTransactionResponse.CategoryCode.others)
        let iconImage = DataHelperUtil.shared.iconFromCategory(code, largeIcon: true)
        let smallIconImage = DataHelperUtil.shared.iconFromCategory(code, largeIcon: false)
        categoryIconImageView.image = UIImage.init(named: iconImage)
        transactionDescriptionLabel.text = self.viewModel.data.merchant
        transactionDescriptionLabel.font = AppConfig.shared.activeTheme.mediumBoldFont
        transactionDescriptionLabel.textColor = AppConfig.shared.activeTheme.textColor
        transactionDateLabel.text = self.viewModel.data.date
        transactionDateLabel.textColor = AppConfig.shared.activeTheme.lightGrayColor
        transactionAmountLabel.text = FormatterUtil.shared.currencyFormat(self.viewModel.data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
        transactionAmountLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        categoryTitleImageIconView.image = UIImage.init(named: smallIconImage)
        categoryTitleLabel.text = self.viewModel.data.categoryTitle ?? ""
        let url = URL.init(string: self.viewModel.data.financialInstitutionLogoUrl ?? "")
        financialInstitutionImageIconView.sd_imageIndicator = SDWebImageActivityIndicator.gray;
        financialInstitutionImageIconView.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            self.financialInstitutionImageIconView.image = image
        })
    }
    
    @objc func dismissAction() {
        SwiftEntryKit.dismiss()
    }
}
