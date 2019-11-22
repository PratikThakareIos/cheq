//
//  SpendingCardTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit



class SpendingCardTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: CGradientView!
    @IBOutlet weak var progressBarViewContainer: UIView!
    @IBOutlet weak var progressBarView: CProgressView!
    @IBOutlet weak var headerLabel: CLabel!
    @IBOutlet weak var countDownLabel: CLabel!
    @IBOutlet weak var nextPayCycleLabel: CLabel!
    @IBOutlet weak var subHeaderLabel: CLabel!
    var gradient: CAGradientLayer = CAGradientLayer()
    let payCycleDays: Double = 14.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = SpendingCardTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight*2)
        }
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear
        headerLabel.font = AppConfig.shared.activeTheme.extraLargeBoldFont
        headerLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        subHeaderLabel.font = AppConfig.shared.activeTheme.defaultFont
        subHeaderLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        countDownLabel.font = AppConfig.shared.activeTheme.defaultFont
        countDownLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        nextPayCycleLabel.font = AppConfig.shared.activeTheme.defaultFont
        nextPayCycleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        
        let gradientSet = AppConfig.shared.activeTheme.gradientSet4
        containerView.startColor = gradientSet.first ?? .white
        containerView.endColor = gradientSet.last ?? .white

        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
        
        let vm = self.viewModel as! SpendingCardTableViewCellViewModel
        if let startDate = vm.data.payCycleStartDate, let endDate = vm.data.payCycleEndDate, startDate.isEmpty == false, endDate.isEmpty == false {
            nextPayCycleLabel.text = "\(startDate) - \(endDate)"
        } else {
            nextPayCycleLabel.text = ""
        }
        
        if let remaining = vm.data.numberOfDaysTillPayday {
            countDownLabel.text = "\(remaining) days til payday"
            progressBarView.mode = .gradientMonetary
            progressBarView.progress = Float(Double(remaining) / payCycleDays)
            progressBarView.setupConfig()
        } else {
            countDownLabel.text = ""
            progressBarView.progress = 0.0
        }
        
        self.containerView.bringSubviewToFront(progressBarView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = self.containerView.layer.sublayers?[0] as? CAGradientLayer {
            gradient.frame = self.bounds
        }
    }
    
}
