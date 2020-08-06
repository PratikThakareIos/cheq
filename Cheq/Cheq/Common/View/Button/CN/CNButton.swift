//
//  CNButton.swift
//  Cheq
//
//  Created by Manish.D on 11/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import MHLoadingButton

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

//class CNButton: UIButton {
class CNButton: LoadingButton {
    
    /// Default button type to **normal**
    var type: CNButtonType = .normal
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
    
//    override func layoutSubviews() {
//         super.layoutSubviews()
//
//         if shadow_Layer == nil {
//            self.createShadowLayer()
//         }
//     }
    
    /// Styling logics is kept here and re-usable.
    func setupConfig() {

     
        let title =  self.titleLabel?.text ?? ""
        self.setTitle(title)
        self.cornerRadius = self.frame.height/2
        self.indicator = BallPulseIndicator(color: .white)
        self.bgColor = AppConfig.shared.activeTheme.primaryColor
        self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        
        //self.withShadow = true
        //self.shadowAdded = true
        //let layerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width+1, height: self.frame.size.height+1))
        //layerView.backgroundColor = .red
        //self.shadowLayer = layerView
        
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            self.layer.cornerRadius = self.frame.height/2
            self.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
        })
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

// MARK: LoadingButton
extension CNButton {

    func showLoadingOnButton(_ viewController : UIViewController) {
        self.showLoader(userInteraction: false)
        viewController.view.isUserInteractionEnabled =  false
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func hideLoadingOnButton(_ viewController : UIViewController){
        self.hideLoader()
        viewController.view.isUserInteractionEnabled =  true
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
}

extension CNButton {
    
     func createShadowLayer(){
        //self.layer.masksToBounds = false;
        self.layer.shadowRadius  = 3.0;
        self.layer.shadowColor   = AppConfig.shared.activeTheme.primaryColor.cgColor;
        self.layer.shadowOffset  = CGSize(width: 3.0, height: 4.0);
        self.layer.shadowOpacity = 0.3;
        
     }
    
     func createShadowLayer11(){

            shadow_Layer = CAShapeLayer()
            shadow_Layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
            shadow_Layer.fillColor = UIColor.clear.cgColor//AppConfig.shared.activeTheme.primaryColor.cgColor
            shadow_Layer.shadowPath = shadow_Layer.path
            shadow_Layer.shadowRadius = 3.0
            shadow_Layer.shadowColor = AppConfig.shared.activeTheme.primaryColor.cgColor
            shadow_Layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            shadow_Layer.shadowOpacity = 0.3
            shadow_Layer.shadowPath = shadow_Layer.path

            layer.insertSublayer(shadow_Layer, at: 0)
    }
}


class RoundedButtonWithShadow: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
}


///**
// CNButton is for encapsulation of styling logics which is applied across **UIButton** in the app.
// */
//class CNButton: UIButton {
//
//    /// Default button type to **normal**
//    var type: CNButtonType = .normal
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.titleLabel?.textAlignment = .center
//        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
//        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
//            self.layer.cornerRadius = self.frame.height/2
//            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
//        })
//    }
//
//    /// Added **setupConfig** to default init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupConfig()
//    }
//
//    /// Added **setupConfig** to default init with coder
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupConfig()
//    }
//
//    /// Styling logics is kept here and re-usable.
//    func setupConfig() {
//        //self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
//        //self.titleLabel?.font = AppConfig.shared.activeTheme.mediumMediumFont
//        //self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
//        //var button = self as UIButton
//        //AppConfig.shared.activeTheme.roundRectButton(&button)
//
//        self.titleLabel?.textAlignment = .center
//        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
//        self.titleLabel?.font = AppConfig.shared.activeTheme.headerMediumFont
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
//            self.layer.cornerRadius = self.frame.height/2
//            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
//        })
//    }
//
//    /// When a type is set, the styling is automatically applied
//    func setType(_ type: CNButtonType) {
//        self.type = type
//        switch type {
//        case .normal:
//            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
//            self.setTitleColor(AppConfig.shared.activeTheme.altTextColor, for: .normal)
//        case .alternate:
//            self.titleLabel?.textColor = AppConfig.shared.activeTheme.primaryColor
//            self.setTitleColor(AppConfig.shared.activeTheme.primaryColor, for: .normal)
//            self.backgroundColor = .clear
//        }
//    }
//}


