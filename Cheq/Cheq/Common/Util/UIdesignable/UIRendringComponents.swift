//
//  UIRendringComponents.swift
//  SafariAdBlocker
//
//  Created by Manish.Dodia on 05/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import UIKit


final class AutoSizeShadowButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.layer.cornerRadius = self.frame.height/2
            //self.createShadowLayer()
        })
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer != nil {
            shadowLayer.fillColor = UIColor(hex: "4A0067").cgColor //AppConfig.shared.activeTheme.primaryColor
            self.reloadText()
        }
    }
    
    
    
    
    fileprivate func createShadowLayer(){
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor(hex: "4A0067").cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 4
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    fileprivate func deviceSize() -> CGSize {
        return (UIApplication.shared.delegate?.window?!.frame.size)!
    }
    
    fileprivate func reloadText(){
        //set Localizable title
        var title = ""
        if self.isSelected{
            title = self.title(for: .selected)!
            self.setTitle(title, for: .selected)
        }else{
            title = self.title(for: .normal)!
            self.setTitle(title, for: .normal)
        }
    }
}

class RoundedTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = AppConfig.shared.activeTheme.mediumFont
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10, execute: {
            self.layer.cornerRadius = self.frame.height/2
        })
    }
}

class AutoRadius: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10, execute: {
            self.layer.cornerRadius = self.frame.height/2
        })
    }
}



