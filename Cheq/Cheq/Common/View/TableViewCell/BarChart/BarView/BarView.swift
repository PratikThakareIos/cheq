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
    @IBOutlet weak var amountLabel: UILabel!
    
    /// Refer to **xib** layout
    @IBOutlet weak var label: UILabel!
    
    /// Refer to **xib** layout. BarView background is gradient view by design.
    @IBOutlet weak var barTint: CGradientView!
    
    /// ContainerView for the bar
    @IBOutlet weak var containerView: UIView!
    
    /// Use progress constraint to update the height of the **BarView**
    @IBOutlet weak var progress: NSLayoutConstraint!
    
    /// Width constraint of progress bar
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint! 
    
    /// The container is set to 25% of screen height
    let barHeight : CGFloat = 110.0 //AppConfig.shared.screenHeight() * 0.25
    
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
        
        self.amountLabel.font = UIFont.init(name: FontConstant.SFProTextMedium, size: 13.0) ?? UIFont.systemFont(ofSize: 13.0, weight: .medium)
        self.amountLabel.textColor = viewModel.barViewState == BarViewState.active ?  UIColor(hex: "111111") :  UIColor(hex: "333333").withAlphaComponent(0.75)
        self.amountLabel.text = FormatterUtil.shared.currencyFormat(viewModel.amount, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: true)
                
        self.label.font = UIFont.init(name: FontConstant.SFProTextMedium, size: 13.0) ?? UIFont.systemFont(ofSize: 13.0, weight: .medium)
        self.label.textColor = viewModel.barViewState == BarViewState.active ?  UIColor(hex: "111111") :  UIColor(hex: "111111").withAlphaComponent(0.75)
        self.label.text = viewModel.label
        
        let heightOfBar = self.viewModel.progress * barHeight
        self.progress.constant = heightOfBar < 8 ? 8 : heightOfBar
        self.progressBarWidth.constant = self.viewModel.barWidth
        self.layoutIfNeeded()
        
        var barTint = self.barTint ?? UIView()
        ViewUtil.shared.circularMask(&barTint, radiusBy: .width)
        barTint.alpha = viewModel.barViewState == BarViewState.active ? 1.0 : 0.75
        barTint.backgroundColor = .clear
       
                
//        var fistColor =  UIColor(hex: "FF8141")
//        var lastColor =  UIColor(hex: "D60A5F")
//
//        if viewModel.barViewState == BarViewState.active {
//            fistColor =  UIColor(hex: "F1663C")
//            lastColor =  UIColor(hex: "D52955")
//        }
//
//
//        let gradient = CAGradientLayer(start: .topCenter, end: .bottomCenter, colors: [fistColor.cgColor, lastColor.cgColor], type: .axial)
//        gradient.frame = barTint.bounds
//        barTint.layer.addSublayer(gradient)
        
    }
}
