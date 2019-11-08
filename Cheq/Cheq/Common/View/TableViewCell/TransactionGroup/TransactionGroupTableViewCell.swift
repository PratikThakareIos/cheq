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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        self.viewModel = TransactionGroupTableViewCellViewModel()
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
        self.categoryAmount.text = FormatterUtil.shared.currencyFormat(vm.data.categoryAmount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue)
        self.categoryIcon.image = UIImage.init(named: self.iconFromCategory(vm.data))
    }
    
    func iconFromCategory(_ response: CategoryAmountStatResponse)-> String {
        
        let code: CategoryAmountStatResponse.CategoryCode = response.categoryCode ?? CategoryAmountStatResponse.CategoryCode.others
        switch code {
        case .benefits:
            return LargeCategoryEmoji.benefits.rawValue
        case .bills:
            return LargeCategoryEmoji.billsUtilities.rawValue
        case .employmentIncome:
            return LargeCategoryEmoji.employmentIncome.rawValue
        case .entertainment:
            return LargeCategoryEmoji.entertainment.rawValue
        case .financialServices:
            return LargeCategoryEmoji.financialServices.rawValue
        case .fitness:
            return LargeCategoryEmoji.billsUtilities.rawValue
        case .groceries:
            return LargeCategoryEmoji.groceries.rawValue
        case .health:
            return LargeCategoryEmoji.health.rawValue
        case .household:
            return LargeCategoryEmoji.homeFamily.rawValue
        case .ondemandIncome:
            return LargeCategoryEmoji.ondemandIncome.rawValue
        case .others:
            return LargeCategoryEmoji.other.rawValue
        case .otherDeposit:
            return LargeCategoryEmoji.otherDeposits.rawValue
        case .restaurantsAndCafes:
            return LargeCategoryEmoji.restaurantsCafe.rawValue
        case .shopping:
            return LargeCategoryEmoji.shopping.rawValue
        case .secondaryIncome:
            return LargeCategoryEmoji.secondaryIncome.rawValue
        case .tobaccoAndAlcohol:
            return LargeCategoryEmoji.tobaccoAlcohol.rawValue
        case .transport:
            return LargeCategoryEmoji.transport.rawValue
        case .travel:
            return LargeCategoryEmoji.travel.rawValue
        case .workAndEducation:
            return LargeCategoryEmoji.work.rawValue
        }
    }
}
