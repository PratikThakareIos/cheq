//
//  TransferCardTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
TransferCardTableViewCell is UI implementation of transfer card on Lending screen.
 */
class TransferCardTableViewCell: CTableViewCell {

    /// refer to **xib**
    @IBOutlet weak var amountLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var feeLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var transferIcon: UIImageView!
    
    /// refer to **xib**
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var dateString: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var containerView: UIView!
    
    
     @IBOutlet weak var fundClearanceLabel: UILabel!

    /// method executed when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = TransferCardTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    /// setupConfig applies the UI update to the tableview cell, call this after we updated viewModel 
    override func setupConfig() {
        
        let vm = self.viewModel as! TransferCardTableViewCellViewModel
        self.backgroundColor = .clear
                
//        let bgColor: UIColor = (vm.direction == .debit) ? AppConfig.shared.activeTheme.alternativeColor3 : AppConfig.shared.activeTheme.monetaryColor
//
//        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: bgColor.withAlphaComponent(0.05), applyShadow: false)
//        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor)
        
        self.containerView.backgroundColor = .white
        
        AppConfig.shared.activeTheme.cardStyling(self.containerView, bgColor: .white, applyShadow: false)
        
        if vm.direction == .credit {
           self.amountLabel.textColor = AppConfig.shared.activeTheme.splashBgColor2
           self.amountLabel.font = UIFont.init(name: FontConstant.SFProTextBold, size: 24.0) ?? UIFont.systemFont(ofSize: 24.0, weight: .bold)
           self.fundClearanceLabel.isHidden = false
        }else{
           self.amountLabel.textColor = UIColor(hex: "059AEC")
           self.amountLabel.font = UIFont.init(name: FontConstant.SFProTextBold, size: 20.0) ?? UIFont.systemFont(ofSize: 20.0, weight: .bold)
           self.fundClearanceLabel.isHidden = true
        }
        
        self.amountLabel.text = vm.transferAmount
        self.amountLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        
        self.descriptionLabel.text = vm.descriptionText()
        //self.descriptionLabel.font = AppConfig.shared.activeTheme.mediumFont
        
        self.feeLabel.text = vm.feeAmountText
        self.feeLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.feeLabel.textColor = AppConfig.shared.activeTheme.lightestGrayColor
        self.dateString.text = vm.getFormattedDate() //vm.dateString
        let transferImage = vm.imageIcon()
        self.transferIcon.image = UIImage(named: transferImage)

    }
}
