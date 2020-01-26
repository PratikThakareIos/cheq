//
//  CProgressView.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 There are different color/gradient setting for progress bars, **CProgressColorMode** keeps track of the different type of settings we have.
 */
enum CProgressColorMode {
    
    /// this is used during onboarding
    case information
    
    /// the green progress bar color on Lending screen
    case monetary
    
    //// the green progress bar color with gradient on Spending screen
    case gradientMonetary
}

/**
 CProgressView is subclass of **UIProgressView**. The prefix character *C* is usually a naming pattern across the custom views created.
 */
class CProgressView: UIProgressView {
    
    /// variable to track what **CProgressColorMode** is
    var mode: CProgressColorMode = .information
    
    /// init method from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }
    
    /// Adding **setupConfig** to init method by frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Adding **setupConfig** to init method coder. This is used by Storyboard.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    /// progress bar is styled based on **CProgressColorMode** setting
    func setupConfig() {
        self.backgroundColor = .clear
        self.trackTintColor = AppConfig.shared.activeTheme.alternativeColor4
        switch mode {
        case .information:
            self.progressTintColor = AppConfig.shared.activeTheme.alternativeColor3
        case .monetary:
            self.progressTintColor = AppConfig.shared.activeTheme.monetaryColor
        case .gradientMonetary:
            let gradientImage = UIImage.gradientImage(with: self.frame,
                                                      colors: [AppConfig.shared.activeTheme.alternativeColor3.cgColor, AppConfig.shared.activeTheme.monetaryColor.cgColor],
                                                      locations: nil)
            self.progressImage = gradientImage
        }
       
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: false)
        layer.cornerRadius = 5.0
    }
    
    
    /// adding intrinsic content size, autolayout constraints can override the dimension settings
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: AppConfig.shared.screenWidth() * 0.2 , height: AppConfig.shared.activeTheme.defaultProgressBarHeight)
        }
    }
}
