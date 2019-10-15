//
//  CProgressView.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum CProgressColorMode {
    case information
    case monetary
}

class CProgressView: UIProgressView {
    
    var mode: CProgressColorMode = .information
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    func setupConfig() {
        self.backgroundColor = .clear
        self.trackTintColor = AppConfig.shared.activeTheme.alternativeColor4
        self.progressTintColor = (mode == .information) ? AppConfig.shared.activeTheme.alternativeColor3 : AppConfig.shared.activeTheme.monetaryColor
        
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: false)
        layer.cornerRadius = 5.0
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.size.width * 0.2 , height: AppConfig.shared.activeTheme.defaultProgressBarHeight)
        }
    }
}
