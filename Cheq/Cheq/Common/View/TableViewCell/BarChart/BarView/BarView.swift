//
//  BarView.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 BarView renders for one bar amongst the bar chart on **BarChartTableViewCell**
 */
class BarView: UIView {
    
    /// The amount label, which shows at the top of the bar. Refer to **xib** layout
    @IBOutlet weak var amountLabel: CLabel!
    
    /// Refer to **xib** layout
    @IBOutlet weak var label: CLabel!
    
    /// Refer to **xib** layout. BarView background is gradient view by design.
    @IBOutlet weak var barTint: CGradientView!
    
    /// ContainerView for the bar
    @IBOutlet weak var containerView: UIView!
    
    /// Use progress constraint to update the height of the **BarView**
    @IBOutlet weak var progress: NSLayoutConstraint!
    
    /// Width constraint of progress bar
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint! 
    
    /// The container is set to 25% of screen height
    let barHeight = AppConfig.shared.screenHeight() * 0.25
    
    /// Initialise viewModel which comes with dummy values
    var viewModel = BarViewModel()
    
    /// awakeFromNib is called when intialised by **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }
    
     /// call setupConfig whenever we want to update BarView by viewModel 
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
}
