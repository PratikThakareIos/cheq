//
//  BarView.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BarView: UIView {
    
    @IBOutlet weak var amountLabel: CLabel!
    @IBOutlet weak var label: CLabel!
    @IBOutlet weak var barTint: CGradientView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progress: NSLayoutConstraint!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint! 
    
    
    let barHeight = AppConfig.shared.screenHeight() * 0.25
    var viewModel = BarViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }
    
    func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.amountLabel.font = AppConfig.shared.activeTheme.mediumFont
        self.amountLabel.textColor = AppConfig.shared.activeTheme.textColor
        self.amountLabel.text = FormatterUtil.shared.currencyFormat(viewModel.amount, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: true)
        var barTint = self.barTint ?? UIView()
        ViewUtil.shared.circularMask(&barTint, radiusBy: .width)
        barTint.alpha = viewModel.barViewState == BarViewState.active ? 1.0 : AppConfig.shared.activeTheme.nonActiveAlpha
        self.label.font = AppConfig.shared.activeTheme.defaultFont
        self.label.textColor = AppConfig.shared.activeTheme.textColor
        self.label.text = viewModel.label
        self.progress.constant = self.viewModel.progress * barHeight
        self.progressBarWidth.constant = self.viewModel.barWidth
    }
    
//    func animate() {
//        LoggingUtil.shared.cPrint("animate bar view here")
//        self.progress.constant = 0.0
//        UIView.animate(withDuration: AppConfig.shared.activeTheme.quickAnimationDuration) {
//            self.progress.constant = self.viewModel.progress * self.barHeight
//        }
//    }
}
