//
//  AppThemeProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

// by adopting AppThemeProtocol
protocol AppThemeProtocol {

    //MARK: theme info
    var themeTitle: String { get }

    //MARK: fonts
    var defaultFont: UIFont { get }
    var mediumFont: UIFont { get }
    var headerFont: UIFont { get }
    var extraLargeFont: UIFont { get }

    //MARK: colors
    var barStyle: UIBarStyle { get }
    var textColor: UIColor { get }
    var altTextColor: UIColor { get }
    var linksColor: UIColor { get }
    var primaryColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var textBackgroundColor: UIColor { get }
    var alternativeColor1: UIColor { get }
    var alternativeColor2: UIColor { get }
    var alternativeColor3: UIColor { get }
    var alternativeColor4: UIColor { get }
    var facebookColor: UIColor { get }
    var nonActiveAlpha: CGFloat { get }
    
    // monetary color
    var monetaryColor: UIColor { get }
    
    // gray scale system color
    var lightGrayScaleColor: UIColor { get }
    var lightGrayBorderColor: UIColor { get }
    
    // gray system color
    var darkGrayColor: UIColor { get }
    var mediumGrayColor: UIColor { get }
    var lightGrayColor: UIColor { get }
    var lightestGrayColor: UIColor { get }

    //MARK: gradients
    var gradientSet1: [UIColor] { get }
    var gradientSet2: [UIColor] { get }
    var gradientSet3: [UIColor] { get }
    
    
    var gradientSet4: [UIColor] { get }
    var gradientSet5: [UIColor] { get }
    
    func allBgColors()-> [UIColor]

    //MARK: animations
    var longAnimationDuration: TimeInterval { get }
    var mediumAnimationDuration: TimeInterval { get }
    var quickAnimationDuration: TimeInterval { get }
    
    //MARK: common paddings
    var xsPadding: Double { get }
    var sPadding: Double { get }
    var mPadding: Double { get }
    var lPadding: Double { get }
    var xlPadding: Double { get }
    var xxlPadding: Double { get }

    //MARK: styling logics
    var padding: CGFloat { get }
    var gridCellToScreenRatio: CGFloat { get }
    var carouselCellWidthToScreenRatio: CGFloat { get }
    var carouselCellHeightToScreenRatio: CGFloat { get }
    var popoverMenuLabelHeight: CGFloat { get }
    var popoverMenuToScreenWidthRatio: CGFloat { get }
    var defaultButtonHeight: CGFloat { get }
    var defaultCornerRadius: CGFloat { get }
    var defaultProgressBarHeight: CGFloat { get }
    
    func cardStyling(_ view: UIView, borderColor: UIColor?)
    func cardStyling(_ view: UIView, addBorder: Bool) 
    func cardStyling(_ view: UIView, bgColors: [UIColor])
    func cardStyling(_ view: UIView, bgColor: UIColor, applyShadow: Bool)
    func collectionViewPadding(_ collectionView: UICollectionView, cellLength: CGFloat, collectionType: CollectionViewType)
    func roundRectButton(_ button: inout UIButton)
}

// MARK: Styling logics 
extension AppThemeProtocol {

    var defaultCornerRadius: CGFloat { get { return 20.0 } }
    var defaultButtonHeight: CGFloat { get { return 56.0 }}
    var defaultTextFieldHeight: CGFloat { get { return 56.0 }}
    var defaultProgressBarHeight: CGFloat { get { return 6.0 }}
    var popoverMenuLabelHeight: CGFloat { get { return 40.0 } }
    var popoverMenuToScreenWidthRatio: CGFloat { get { return 0.5 } }

    func roundRectButton(_ button: inout UIButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        button.clipsToBounds = true
    }
    
    func cardStyling(_ view: UIView, bgColor: UIColor, applyShadow: Bool) {
        view.backgroundColor = bgColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        if applyShadow {
            view.layer.shadowPath =
                UIBezierPath(roundedRect: view.layer.bounds,
                             cornerRadius: view.layer.cornerRadius).cgPath
            view.layer.shadowColor = textColor.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize(width: 5, height: 5)
            view.layer.shadowRadius = view.layer.cornerRadius / 2.0
        }
    }
    
    func cardStyling(_ view: UIView, borderColor: UIColor?) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        if let color = borderColor {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = color.cgColor
        }
    }

    func cardStyling(_ view: UIView, addBorder: Bool) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        if addBorder {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    func cardStyling(_ view: UIView, bgColors: [UIColor]) {
        // setup gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.masksToBounds = false
        gradientLayer.frame = view.layer.bounds
        gradientLayer.colors = bgColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.opacity = 0.8;
        gradientLayer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        gradientLayer.shadowPath =
            UIBezierPath(roundedRect: gradientLayer.bounds,
                         cornerRadius: gradientLayer.cornerRadius).cgPath
        gradientLayer.shadowColor = UIColor.black.cgColor
        gradientLayer.shadowOpacity = 0.2
        gradientLayer.shadowOffset = CGSize(width: 5, height: 5)
        gradientLayer.shadowRadius = gradientLayer.cornerRadius / 2.0
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func allBgColors()-> [UIColor] {
        return [alternativeColor1, alternativeColor2, alternativeColor3, alternativeColor4]
    }

    func collectionViewPadding(_ collectionView: UICollectionView, cellLength: CGFloat, collectionType: CollectionViewType) {
        switch(collectionType) {

        // for carousel
        case .carousel:
            collectionView.contentInset = UIEdgeInsets(top: padding, left: cellLength*0.25, bottom: padding, right: cellLength*0.25)

        // for grid view
        case .grid:
            collectionView.contentInset = UIEdgeInsets(top: padding, left: cellLength*0.25, bottom: padding, right: cellLength*0.25)
        }
    }

    var padding: CGFloat {
        get { return 10.0 }
    }
    
    var xsPadding: Double { get { return 4.0 } }
    var sPadding: Double { get { return 8.0 } }
    var mPadding: Double { get { return 16.0 } }
    var lPadding: Double { get { return 24.0 } }
    var xlPadding: Double { get { return 32.0 } }
    var xxlPadding: Double { get { return 40.0 }}

    var nonActiveAlpha: CGFloat { get { return 0.5 } }

    var defaultFont: UIFont {
        get { return UIFont.systemFont(ofSize: 12.0)}
    }

    var mediumFont: UIFont {
        get { return UIFont.systemFont(ofSize: 15.0)}
    }

    var headerFont: UIFont {
        get { return UIFont.systemFont(ofSize: 20.0)}
    }
    
    var extraLargeFont: UIFont {
        get { return UIFont.systemFont(ofSize: 36.0)}
    }

    var longAnimationDuration: TimeInterval { return 1.0 }
    var mediumAnimationDuration: TimeInterval { return 0.5 }
    var quickAnimationDuration: TimeInterval { return 0.25}

    var gridCellToScreenRatio: CGFloat { get { return 0.35 } }
    var carouselCellWidthToScreenRatio: CGFloat { get { return 0.6 } }
    var carouselCellHeightToScreenRatio: CGFloat { get { return 0.25 } }
    
    var facebookColor: UIColor {
        get { return UIColor(hex: "3B5998")}
    }
    
    var altTextColor: UIColor {
        get { return .white }
    }

    var monetaryColor: UIColor {
        get { return UIColor(hex: "10E483") }
    }
    
    // gray scale system color
    var lightGrayScaleColor: UIColor {
        get { return UIColor(hex: "EDECEE") }
    }

     var lightGrayBorderColor: UIColor {
        get { return UIColor(hex: "E0E0E0") }
    }
    
    // gray system color
    var darkGrayColor: UIColor {
        get { return UIColor(hex: "111111") }
    }
    
    var mediumGrayColor: UIColor {
        get { return UIColor(hex: "333333") }
    }
    
    var lightGrayColor: UIColor {
        get { return UIColor(hex: "666666") }
    }
    
    var lightestGrayColor: UIColor {
        get { return UIColor(hex: "999999") }
    }
}
