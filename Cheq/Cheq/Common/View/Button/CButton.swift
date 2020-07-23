//
//  CButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 Different **CButtonType** setting for different styling. **normal** is button with solid primary background color and white text, **alternate** is white background with primary color text.
 */
enum CButtonType {
    case normal
    case alternate
}

/**
 CButton is for encapsulation of styling logics which is applied across **UIButton** in the app.
 */
class CButton: UIButton {
    
    /// Default button type to **normal**
    var type: CButtonType = .normal

    /// Added **setupConfig** to default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Added **setupConfig** to default init with coder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// The width is expanded by 25% for spacing because we round-cornered our button margins.
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width * 1.25, height: AppConfig.shared.activeTheme.defaultButtonHeight)
        }
    }
    
    /// Styling logics is kept here and re-usable.
    func setupConfig() {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
        self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        var button = self as UIButton
        //AppConfig.shared.activeTheme.roundRectButton(&button)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            self.layer.cornerRadius = self.frame.height/2
        })
    }
    
    /// When a type is set, the styling is automatically applied 
    func setType(_ type: CButtonType) {
        self.type = type
        switch type {
        case .normal:
            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
            self.setTitleColor(AppConfig.shared.activeTheme.altTextColor, for: .normal)
        case .alternate:
            self.titleLabel?.textColor = AppConfig.shared.activeTheme.primaryColor
            self.setTitleColor(AppConfig.shared.activeTheme.primaryColor, for: .normal)
            self.backgroundColor = .clear
        }
    }
}

extension CButton {
     func createShadowLayer() {
        self.layer.masksToBounds = false;
        self.layer.shadowRadius  = 3.0;
        self.layer.shadowColor   = AppConfig.shared.activeTheme.primaryColor.cgColor;
        self.layer.shadowOffset  = CGSize(width: 3.0, height: 4.0);
        self.layer.shadowOpacity = 0.3;
     }
}
