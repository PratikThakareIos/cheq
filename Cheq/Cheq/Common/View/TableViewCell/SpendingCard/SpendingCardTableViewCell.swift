//
//  SpendingCardTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit


/**
 SpendingCardTableViewCell is the implementation for the card on Spending Overview screen
 */
class SpendingCardTableViewCell: CTableViewCell {
    
    /// update background and margins using containerView
    @IBOutlet weak var containerView: CGradientView!
    
    
    /// view for Shadow
   // @IBOutlet weak var ViewShadow: UIView!
    
    /// container view for progressBarView
    @IBOutlet weak var progressBarViewContainer: UIView!
    
    /// refer to **xib**
    @IBOutlet weak var progressBarView: CProgressView!
    
    /// refer to **xib**
    @IBOutlet weak var headerLabel: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var countDownLabel: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var nextPayCycleLabel: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var subHeaderLabel: CLabel!
    
    /// gradient layer for background
    var gradient: CAGradientLayer = CAGradientLayer()
    
    /// constant value for calculation purpose
    let payCycleDays: Double = 14.0
    
    
    /// init method from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = SpendingCardTableViewCellViewModel()
        setupConfig()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// the intrinsic height for the card, we don't need to define this if we want to purely rely on autolayout constraints
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight*2)
        }
    }
    
    ///  method to style and update the UI 
    override func setupConfig() {
        self.backgroundColor = .clear
        headerLabel.font = AppConfig.shared.activeTheme.extraLargeBoldFont
        headerLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        subHeaderLabel.font = AppConfig.shared.activeTheme.mediumFont
        subHeaderLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.75)//AppConfig.shared.activeTheme.altTextColor
        countDownLabel.font = AppConfig.shared.activeTheme.defaultFont
        //countDownLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        countDownLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.9)
        nextPayCycleLabel.font = AppConfig.shared.activeTheme.defaultFont
        //nextPayCycleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        nextPayCycleLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.9)
        
        let gradientSet = AppConfig.shared.activeTheme.gradientSet4
        containerView.startColor = gradientSet.first ??  UIColor(hex: "BD004F") //AppConfig.shared.activeTheme.lightGrayScaleColor
        containerView.endColor = gradientSet.last ??  UIColor(hex: "E07843") //AppConfig.shared.activeTheme.lightGrayScaleColor

        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
               
        let vm = self.viewModel as! SpendingCardTableViewCellViewModel
        if let startDate = vm.data.payCycleStartDate, let endDate = vm.data.payCycleEndDate, startDate.isEmpty == false, endDate.isEmpty == false {
            
        let strConverted_startDate = convertDateFormater(startDate) ?? startDate
        let strConverted_endDate = convertDateFormater(endDate) ?? endDate
            
            
            nextPayCycleLabel.text = "\(strConverted_startDate) - \(strConverted_endDate)"
        } else {
            nextPayCycleLabel.text = ""
        }
        
        if let remaining = vm.data.numberOfDaysTillPayday {
            countDownLabel.text = "\(remaining) days till payday"
            progressBarView.mode = .gradientMonetary
            progressBarView.progress = Float(Double(remaining) / payCycleDays)
            progressBarView.setupConfig()
        } else {
            countDownLabel.text = ""
            progressBarView.progress = 0.0
        }
        
        self.containerView.bringSubviewToFront(progressBarView)
        self.setShadowOnCard()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = self.containerView.layer.sublayers?[0] as? CAGradientLayer {
            gradient.frame = self.bounds
        }
    }
    
    func convertDateFormater(_ date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd MMM"
            return  dateFormatter.string(from: date)
        }
        return nil
    }
    
    func setShadowOnCard() {
        //rgba(146,146,210,0.05)
        containerView.layer.masksToBounds = false;
        containerView.layer.shadowRadius  = 3.0;
        containerView.layer.shadowColor   = UIColor.init(r: 249, g: 75, b: 109).cgColor;
        containerView.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
        containerView.layer.shadowOpacity = 0.05;
    }
    
}
