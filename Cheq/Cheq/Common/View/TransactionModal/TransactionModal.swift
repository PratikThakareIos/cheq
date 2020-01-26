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

/**
 TransactionModal is presented when we want to expand details of a transaction
 */
class TransactionModal: UIView {
    
    /// viewModel is always initialised, so it's not nil
    var viewModel = TransactionModalViewModel()
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var categoryIcon: UIView!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var contentContainer: UIView!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var categoryIconImageView: UIImageView!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var transactionDescriptionLabel: CLabel!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var transactionDateLabel: CLabel!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var transactionAmountLabel: CLabel!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var categoryTitleLabel: CLabel!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var categoryTitleImageIconView: UIImageView!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var financialInstitutionLabel: CLabel!
    
    /// refer to **TransactionModal.xib** for the layout of IBOutlet variables
    @IBOutlet weak var financialInstitutionImageIconView: UIImageView!
    

    /// this is called when we initialise from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // setupTapToDismiss()
        setupUI()
    }
    
    /// method to add tap gesture which triggers **dismissAction**
    func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    /**
     SetupUI should be called again once the **viewModel** is populated with the desired values. So **TransactionModal** renders the updated values
     */
    func setupUI() {
        LoggingUtil.shared.cPrint("TransactionModal setupUI")
        
        /// make **categoryIcon** round with **ViewUtil**
        ViewUtil.shared.circularMask(&categoryIcon, radiusBy: .width)
        
        /// **categoryIcon** is container of **financialInstitutionImageIconView**. Make **financialInstitutionImageIconView** round using **ViewUtil**
        var financialIcon = financialInstitutionImageIconView as UIView
        ViewUtil.shared.circularMask(&financialIcon, radiusBy: .height)
        
        /// use method **AppConfig.shared.activeTheme.cardStyling** to make rounded rectangle container view
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
        financialInstitutionLabel.text = self.viewModel.data.financialAccountName
        let remoteBankMapping = AppData.shared.remoteBankMapping
        let bankName = AppData.shared.selectedFinancialInstitution?.name ?? ""
        
        /// grabbing remoteBank using **remoteBankMapping** which is variable of **AppData.shared.remoteBankMapping**. So we can load the corresponding bank logo, because this is not coming back from our data
        if let remoteBank = remoteBankMapping[bankName], let url = URL.init(string: remoteBank.logoUrl) {
            financialInstitutionImageIconView.sd_setImage(with: url, placeholderImage: UIImage.init(named: BankLogo.placeholder.rawValue), options: [], progress: nil, completed: { (image, error, cacheType, imageURL) in
                self.financialInstitutionImageIconView.image = image
            })
        } else {
            /// use placeholder image if there's not corresponding remoteBank that matches the name of the bank from **AppData.shared.selectedFinancialInstitution**
            financialInstitutionImageIconView.image = UIImage.init(named: BankLogo.placeholder.rawValue)
        }
    }
    
    /**
     use **SwiftEntryKit** to dismiss any presented **SwiftEntryKit** view. This is a third party which is used for presenting **TransactionModal**
     */
    @objc func dismissAction() {
        SwiftEntryKit.dismiss()
    }
}
