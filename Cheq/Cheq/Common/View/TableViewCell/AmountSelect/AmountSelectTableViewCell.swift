//
//  AmountSelectTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 AmountSelectTableViewCell is the Amount Select widget implementation. Amount Select widget allows user to select the amount of loan they like to borrow.
 */
class AmountSelectTableViewCell: CTableViewCell {

    /// refer to **xib** for layout
    @IBOutlet weak var controlView: UIView!
    
    /// refer to **xib** for layout
    @IBOutlet weak var infoView: UIView!
    
    /// refer to **xib** for layout
    @IBOutlet weak var loanAmountHeader: UILabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var loanAmount: UILabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var loanAmountCaption: UILabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var increaseLoanAmouontButton: UIButton!
    
    /// refer to **xib** for layout
    @IBOutlet weak var decreaseLoanAmouontButton: UIButton!

    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = AmountSelectTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// call this method when UI is updated
    override func setupConfig() {
        self.backgroundColor = .clear
        ViewUtil.shared.circularMask(&self.controlView, radiusBy: .height)
        ViewUtil.shared.circularMask(&self.infoView, radiusBy: .height)
        ViewUtil.shared.applyBorder(&self.infoView, borderSize: 20.0, color: AppConfig.shared.activeTheme.backgroundColor)

        // loan amount
        self.infoView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.controlView.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
        self.loanAmount.font = AppConfig.shared.activeTheme.headerBoldFont
        self.loanAmount.textColor = AppConfig.shared.activeTheme.textColor
        self.loanAmountHeader.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountHeader.textColor = AppConfig.shared.activeTheme.darkGrayColor
        self.loanAmountCaption.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountCaption.textColor = AppConfig.shared.activeTheme.darkGrayColor
        self.updateControlButtons()
    }

    /// Handling the minus button being pressed. Always calling **updateControlButtons** at the end. This method determines whether the button needs to be disabled from further presses.
    @IBAction func minusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("minusPressed")
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel

        amountSelectViewModel.minus()
        self.updateControlButtons()
    }

    /// Handling the plus button being pressed. Always calling **updateControlButtons** at the end. This method determines whether the button needs to be disabled from further presses.
    @IBAction func plusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("plusPressed")
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel
        amountSelectViewModel.plus()
        self.updateControlButtons()
    }

    /// Text is faded out and button is disabled, when user can't further change the amount for a certain direction. **UpdateControlButtons** handles the checking logics for this.
    func updateControlButtons() {
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel
        self.decreaseLoanAmouontButton.isEnabled = amountSelectViewModel.minusEnabled
        self.increaseLoanAmouontButton.isEnabled = amountSelectViewModel.plusEnabled
        let amount: String = amountSelectViewModel.currentSelectedAmount()
        AppData.shared.amountSelected = amount 
        let loanAmount = String("\(CurrencySymbol.dollar.rawValue)\(amount)")
        let attributedString = NSMutableAttributedString(string: loanAmount)
        attributedString.applyHighlight(loanAmount, color: AppConfig.shared.activeTheme.textColor, font: AppConfig.shared.activeTheme.extraLargeBoldFont)
        self.loanAmount.attributedText = attributedString
    }
}
