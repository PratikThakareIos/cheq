//
//  CPageControl.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CPageControl: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }

    func setupConfig() {
        self.currentPageIndicatorTintColor = AppConfig.shared.activeTheme.alternativeColor3
        self.pageIndicatorTintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
