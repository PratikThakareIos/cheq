//
//  CNButton.swift
//  Cheq
//
//  Created by Manish.D on 11/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

/**
 Different **CNButtonType** setting for different styling. **normal** is button with solid primary background color and white text, **alternate** is white background with primary color text.
 */
enum CNButtonType {
    case normal
    case alternate
}

/**
 CNButton is for encapsulation of styling logics which is applied across **UIButton** in the app.
 */
class CNButton: UIButton {
    
    /// Default button type to **normal**
    var type: CNButtonType = .normal
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10, execute: {
            self.layer.cornerRadius = self.frame.height/2
            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        })
    }

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
    
    /// Styling logics is kept here and re-usable.
    func setupConfig() {
        //self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        //self.titleLabel?.font = AppConfig.shared.activeTheme.mediumMediumFont
        //self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        //var button = self as UIButton
        //AppConfig.shared.activeTheme.roundRectButton(&button)
    }
    
    /// When a type is set, the styling is automatically applied
    func setType(_ type: CNButtonType) {
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


extension CNButton {
     func createShadowLayer(){
        self.layer.masksToBounds = false;
        self.layer.shadowRadius  = 3.0;
        self.layer.shadowColor   = AppConfig.shared.activeTheme.primaryColor.cgColor;
        self.layer.shadowOffset  = CGSize(width: 3.0, height: 4.0);
        self.layer.shadowOpacity = 0.3;
     }
}
