//
//  AmountSelectTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AmountSelectTableViewCell: CTableViewCell {

    // Loan amount control
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var loanAmountHeader: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var loanAmountCaption: UILabel!
    @IBOutlet weak var increaseLoanAmouontButton: UIButton!
    @IBOutlet weak var decreaseLoanAmouontButton: UIButton!

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

    override func setupConfig() {
        self.backgroundColor = .clear
        ViewUtil.shared.circularMask(&self.controlView, radiusBy: .height)
        ViewUtil.shared.circularMask(&self.infoView, radiusBy: .height)
        ViewUtil.shared.applyBorder(&self.infoView, borderSize: 20.0, color: AppConfig.shared.activeTheme.backgroundColor)

        // loan amount
        self.infoView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.controlView.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
        self.loanAmount.font = AppConfig.shared.activeTheme.headerFont
        self.loanAmount.textColor = AppConfig.shared.activeTheme.textColor
        self.loanAmountHeader.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountHeader.textColor = AppConfig.shared.activeTheme.darkGrayColor
        self.loanAmountCaption.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountCaption.textColor = AppConfig.shared.activeTheme.darkGrayColor
        self.updateControlButtons()
    }

    @IBAction func minusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("minusPressed")
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel

        amountSelectViewModel.minus()
        self.updateControlButtons()
    }

    @IBAction func plusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("plusPressed")
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel
        amountSelectViewModel.plus()
        self.updateControlButtons()
    }

    func updateControlButtons() {
        let amountSelectViewModel = viewModel as! AmountSelectTableViewCellViewModel
        self.decreaseLoanAmouontButton.isEnabled = amountSelectViewModel.minusEnabled
        self.increaseLoanAmouontButton.isEnabled = amountSelectViewModel.plusEnabled
        let amount: String = amountSelectViewModel.currentSelectedAmount()
        AppData.shared.amountSelected = amount 
        let loanAmount = String("$\(amount)")
        let attributedString = NSMutableAttributedString(string: loanAmount)
        attributedString.applyHighlight(amount, color: AppConfig.shared.activeTheme.textColor, font: AppConfig.shared.activeTheme.extraLargeFont)
        self.loanAmount.attributedText = attributedString
    }
}
