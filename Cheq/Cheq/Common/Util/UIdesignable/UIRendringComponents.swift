//
//  UIRendringComponents.swift
//  SafariAdBlocker
//
//  Created by Manish.Dodia on 05/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import UIKit
import MHLoadingButton

//final class AutoSizeShadowButton: UIButton {

final class AutoSizeShadowButton: LoadingButton {
    
    private var shadow_Layer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupConfig()
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
    
    func setupConfig(){
        
        self.setTitle("Login")
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
        
        print("self.frame.height/2 = \(self.frame.height/2)")
        
        self.cornerRadius = self.frame.height/2
        
        self.bgColor = AppConfig.shared.activeTheme.splashBgColor3
        self.backgroundColor = AppConfig.shared.activeTheme.splashBgColor3
        
        self.indicator = BallPulseIndicator(color: .white)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
            self.cornerRadius = self.frame.height/2
            //self.createShadowLayer()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                  self.layer.cornerRadius = self.frame.height/2
                  self.layer.masksToBounds = true
                  self.cornerRadius = self.frame.height/2
                  //self.createShadowLayer()
        })
        
        if shadowLayer != nil {
            shadow_Layer.fillColor = UIColor(hex: "4A0067").cgColor //AppConfig.shared.activeTheme.primaryColor
            self.reloadText()
        }
    }
    
    fileprivate func createShadowLayer(){
        if shadowLayer == nil {
            shadow_Layer = CAShapeLayer()
            shadow_Layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
            shadow_Layer.fillColor = UIColor.white.cgColor
            
            shadow_Layer.shadowColor = UIColor(hex: "4A0067").cgColor
            shadow_Layer.shadowPath = shadow_Layer.path
            shadow_Layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            shadow_Layer.shadowOpacity = 0.4
            shadow_Layer.shadowRadius = 4
            
            layer.insertSublayer(shadow_Layer, at: 0)
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

// MARK: LoadingButton
extension AutoSizeShadowButton {

    func showLoadingOnButton(_ viewController : UIViewController) {
        self.showLoader(userInteraction: false)
        viewController.view.isUserInteractionEnabled =  false
    }
    
    func hideLoadingOnButton(_ viewController : UIViewController){
        self.hideLoader()
        viewController.view.isUserInteractionEnabled =  true
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



//final class AutoSizeShadowButton: UIButton {
//
//    private var shadowLayer: CAShapeLayer!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.titleLabel?.textAlignment = .center
//        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
//        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            self.layer.cornerRadius = self.frame.height/2
//            //self.createShadowLayer()
//        })
//
//
//        if #available(iOS 13.0, *) {
//            self.view.backgroundColor = .secondarySystemBackground
//            btnLine = LoadingButton(text: "Line", buttonStyle: .outline)
//            btnFill = LoadingButton(text: "Fill", buttonStyle: .fill)
//        } else {
//            self.view.backgroundColor = .white
//            btnLine = LoadingButton(text: "Line", textColor: .black, bgColor: .white)
//            btnLine.setCornerBorder(color: .black, cornerRadius: 12.0, borderWidth: 1.5)
//            btnFill = LoadingButton(text: "Fill", textColor: .white, bgColor: .black)
//        }
//        btnLine.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if shadowLayer != nil {
//            shadowLayer.fillColor = UIColor(hex: "4A0067").cgColor //AppConfig.shared.activeTheme.primaryColor
//            self.reloadText()
//        }
//    }
//
//    fileprivate func createShadowLayer(){
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
//            shadowLayer.fillColor = UIColor.white.cgColor
//
//            shadowLayer.shadowColor = UIColor(hex: "4A0067").cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 3.0, height: 3.0)
//            shadowLayer.shadowOpacity = 0.4
//            shadowLayer.shadowRadius = 4
//
//            layer.insertSublayer(shadowLayer, at: 0)
//        }
//    }
//
//    fileprivate func deviceSize() -> CGSize {
//        return (UIApplication.shared.delegate?.window?!.frame.size)!
//    }
//
//    fileprivate func reloadText(){
//        //set Localizable title
//        var title = ""
//        if self.isSelected{
//            title = self.title(for: .selected)!
//            self.setTitle(title, for: .selected)
//        }else{
//            title = self.title(for: .normal)!
//            self.setTitle(title, for: .normal)
//        }
//    }
//}
