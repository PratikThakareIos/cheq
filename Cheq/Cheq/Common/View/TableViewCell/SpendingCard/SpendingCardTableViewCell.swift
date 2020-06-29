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
    @IBOutlet weak var headerLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var countDownLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var nextPayCycleLabel: UILabel!
    
    /// refer to **xib**
    @IBOutlet weak var subHeaderLabel: UILabel!
    
    /// gradient layer for background
    var gradient: CAGradientLayer = CAGradientLayer()
    
    /// constant value for calculation purpose
    var payCycleDays: Double = 30.0
    
    
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
    
//    /// the intrinsic height for the card, we don't need to define this if we want to purely rely on autolayout constraints
//    override open var intrinsicContentSize: CGSize {
//        get {
//            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight*2)
//        }
//    }
    
    ///  method to style and update the UI 
    override func setupConfig() {
        self.backgroundColor = .clear
        
    
        //headerLabel.font = AppConfig.shared.activeTheme.extraLargeBoldFont
        //headerLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        
        //subHeaderLabel.font = AppConfig.shared.activeTheme.mediumFont
        subHeaderLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.75)
        
        //countDownLabel.font = AppConfig.shared.activeTheme.defaultFont
        countDownLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.9)
        
        nextPayCycleLabel.font = AppConfig.shared.activeTheme.defaultFont
        nextPayCycleLabel.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.9)



        AppConfig.shared.activeTheme.cardStyling(self.containerView, addBorder: false)
        
        let gradientSet = AppConfig.shared.activeTheme.gradientSet4
        containerView.startColor = gradientSet.first ??  UIColor(hex: "BD004F")
        containerView.endColor = gradientSet.last ??  UIColor(hex: "E07843")
               
        let vm = self.viewModel as! SpendingCardTableViewCellViewModel
        
        let balanceDouble = vm.data.allAccountCashBalance ?? 0.0
        let balanceInInt = Int(balanceDouble)
        headerLabel.text = "$" + balanceInInt.strWithCommas
        
        if let startDate = vm.data.payCycleStartDate, let endDate = vm.data.payCycleEndDate, startDate.isEmpty == false, endDate.isEmpty == false {
            
        let strConverted_startDate = convertDateFormater(startDate) ?? startDate
        let strConverted_endDate = convertDateFormater(endDate) ?? endDate
            nextPayCycleLabel.text = "\(strConverted_startDate) - \(strConverted_endDate)"
        } else {
            nextPayCycleLabel.text = ""
        }
        
        
        if let startDate = vm.data.payCycleStartDate, let endDate = vm.data.payCycleEndDate, startDate.isEmpty == false, endDate.isEmpty == false {
            if let converted_startDate = getDateFromString(startDate), let  converted_endDate = getDateFromString(endDate){
                let diff = converted_endDate.interval(ofComponent: .day, fromDate: converted_startDate)
                LoggingUtil.shared.cPrint(diff)
                payCycleDays = Double(diff)
            }
        }
        
        
        if let remaining = vm.data.numberOfDaysTillPayday {
            
            if remaining == 1 || remaining == 0 {
                countDownLabel.text = "\(remaining) day till payday"
            }else{
                countDownLabel.text = "\(remaining) days till payday"
            }
            progressBarView.mode = .gradientMonetary
            let totalDaysCompleted = payCycleDays - Double(remaining)
            progressBarView.progress = Float(Double(totalDaysCompleted) / payCycleDays)
            progressBarView.setupConfig()
        } else {
            countDownLabel.text = ""
            progressBarView.progress = 0.0
        }
        
        self.containerView.bringSubviewToFront(progressBarView)
        //self.setShadowOnCard()
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
    
    func getDateFromString(_ strDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: strDate) {
             return date
        }
        return nil
    }
    
    func setShadowOnCard() {
        //rgba(146,146,210,0.05)
        containerView.layer.masksToBounds = false;
        containerView.layer.shadowRadius  = 5.0;
        containerView.layer.shadowColor   = UIColor.init(r: 249, g: 75, b: 109).cgColor;
        containerView.layer.shadowOffset  = .zero //CGSize(width: 2.0, height: 4.0);
        containerView.layer.shadowOpacity = 0.35;
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
    }
    
}

//shadowColor: controls the color of the shadow, and can be used to make shadows (dark colors) or glows (light colors). This defaults to black.
//shadowOffset: controls how far the shadow is moved away from its view. This defaults to 3 points up from the view.
//shadowOpacity: controls how transparent the shadow is. This defaults to 0, meaning “invisible”.
//shadowPath: controls the shape of the shadow. This defaults to nil, which causes UIKit to render the view offscreen to figure out the shadow shape.
//shadowRadius: controls how blurred the shadow is. This defaults to 3 points.



