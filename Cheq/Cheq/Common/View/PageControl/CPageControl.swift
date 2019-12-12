//
//  CPageControl.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CPageControl is an subclass from **UIPageControl** where the **AppConfig.shared.activeTheme** styling is applied through using **setupConfig** method. **SetupConfig** method is a consistency across our app for views to update its UI.
 */
class CPageControl: UIPageControl {

    /// init method by class init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// init method when instantiated by storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }

    /// method to stylise using activeTheme 
    func setupConfig() {
        self.currentPageIndicatorTintColor = AppConfig.shared.activeTheme.alternativeColor3
        self.pageIndicatorTintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
