//
//  AppThemeProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

/**
 By adopting AppThemeProtocol, implementing classes will be able create a common interface for all themes. To the outside code, it is merely retrieving the styling from **AppThemeProtocol** interface.
 */
protocol AppThemeProtocol {
    
    /// dark special effect view
    var darkBlurEffectView: UIVisualEffectView { get }
    
    /// dark special effect view
    var lightBlurEffectView: UIVisualEffectView { get }

    //MARK: theme info
    /// title of the theme
    var themeTitle: String { get }

    //MARK: fonts
    /// font interface
    var smallFont: UIFont { get }
    
    /// font interface
    var defaultFont: UIFont { get }
    
    /// font interface
    var mediumFont: UIFont { get }
    
    /// font interface
    var headerFont: UIFont { get }
    
    /// font interface
    var extraLargeFont: UIFont { get }
    
    // MARK: medium fonts
    
    /// medium weighted font interface
    var smallMediumFont: UIFont { get }
    
    /// medium weighted font interface
    var defaultMediumFont: UIFont { get }
    
    /// medium weighted font interface
    var mediumMediumFont: UIFont { get }
    
    /// medium weighted font interface
    var headerMediumFont: UIFont { get }
    
    /// medium weighted font interface
    var extraLargeMediumFont: UIFont { get }
    
    // MARK: bold fonts
    
    /// bold weighted font interface
    var smallBoldFont: UIFont { get }
    
    /// bold weighted font interface
    var defaultBoldFont: UIFont { get }
    
    /// bold weighted font interface
    var mediumBoldFont: UIFont { get }
    
    /// bold weighted font interface
    var headerBoldFont: UIFont { get }
    
    /// bold weighted font interface
    var extraLargeBoldFont: UIFont { get }

    //MARK: colors
    
    /// style of the status bar
    var barStyle: UIBarStyle { get }
    
    /// default textColor is used when we have light background
    var textColor: UIColor { get }
    
    /// alt textColor is used when we have dark background. e.g. Button title.
    var altTextColor: UIColor { get }
    
    /// placeHolderColor is used for UITextField text color
    var placeHolderColor: UIColor { get }
    
    /// links text color
    var linksColor: UIColor { get }
    
    /// primary color is used as background color for normal buttons
    var primaryColor: UIColor { get }
    
    /// default background color on viewControllers
    var backgroundColor: UIColor { get }
    
    /// default background color for text, usually same as **backgroundColor**
    var textBackgroundColor: UIColor { get }
    
    /// alternative colors that belongs to the app's design
    var alternativeColor1: UIColor { get }
    
    /// alternative colors that belongs to the app's design
    var alternativeColor2: UIColor { get }
    
    /// alternative colors that belongs to the app's design
    var alternativeColor3: UIColor { get }
    
    /// alternative colors that belongs to the app's design
    var alternativeColor4: UIColor { get }
    
    /// facebook colors for facebook login button background color
    var facebookColor: UIColor { get }
    
    /// when any view is not acive, then we could apply this alpha value
    var nonActiveAlpha: CGFloat { get }
    
    // monetary color
    var monetaryColor: UIColor { get }
    
    // error color
    var errorColor: UIColor { get }
    
    // gray scale system color
    var lightGrayScaleColor: UIColor { get }
    var lightGrayBorderColor: UIColor { get }
    
    // gray system color
    var darkGrayColor: UIColor { get }
    var mediumGrayColor: UIColor { get }
    var lightGrayColor: UIColor { get }
    var lightestGrayColor: UIColor { get }
    
    //MARK: splash
    var splashBgColor1: UIColor { get }
    var splashBgColor2: UIColor { get }
    var splashBgColor3: UIColor { get }

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
    var xsPadding: CGFloat { get }
    var sPadding: CGFloat { get }
    var mPadding: CGFloat { get }
    var lPadding: CGFloat { get }
    var xlPadding: CGFloat { get }
    var xxlPadding: CGFloat { get }

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

    var defaultCornerRadius: CGFloat { get { return AppConfig.shared.screenHeight() * 0.025 } }
    var defaultButtonHeight: CGFloat { get { return AppConfig.shared.screenHeight() * 0.07 }}
    var defaultTextFieldHeight: CGFloat { get { return AppConfig.shared.screenHeight() * 0.07 }}
    var defaultProgressBarHeight: CGFloat { get { return AppConfig.shared.screenHeight() * 0.01 }}
    var popoverMenuLabelHeight: CGFloat { get { return AppConfig.shared.screenHeight() * 0.05 } }
    var popoverMenuToScreenWidthRatio: CGFloat { get { return 0.5 } }

    func roundRectButton(_ button: inout UIButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        button.clipsToBounds = true
    }
    
    
    /// helper method to apply round rect card styling to a given view.
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
    
    /// helper method to add border to a round-rect view
    func cardStyling(_ view: UIView, borderColor: UIColor?) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        if let color = borderColor {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = color.cgColor
        }
    }

    /// variation of cardStlying method. Adding round-rect and standard light-gray border
    func cardStyling(_ view: UIView, addBorder: Bool) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        if addBorder {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    /// card-styling and adding a gradient background with a given list of colors
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

    /// Helper method returning list of all possible background colors. Implementing classes may have its own logics.
    func allBgColors()-> [UIColor] {
        return [alternativeColor1, alternativeColor2, alternativeColor3, alternativeColor4]
    }

    /// helper method adding padding on collection view
    func collectionViewPadding(_ collectionView: UICollectionView, cellLength: CGFloat, collectionType: CollectionViewType) {
        switch(collectionType) {

        /// for carousel
        case .carousel:
            collectionView.contentInset = UIEdgeInsets(top: padding, left: cellLength*0.25, bottom: padding, right: cellLength*0.25)

        /// for grid view
        case .grid:
            collectionView.contentInset = UIEdgeInsets(top: padding, left: cellLength*0.25, bottom: padding, right: cellLength*0.25)
        }
    }

    /// standard padding size
    var padding: CGFloat {
        get { return 10.0 }
    }
    
    /// A padding system to standardize all padding logics
    var xsPadding: CGFloat { get { return 4.0 } }
    var sPadding: CGFloat { get { return 8.0 } }
    var mPadding: CGFloat { get { return 16.0 } }
    var lPadding: CGFloat { get { return 24.0 } }
    var xlPadding: CGFloat { get { return 32.0 } }
    var xxlPadding: CGFloat { get { return 40.0 }}

    var nonActiveAlpha: CGFloat { get { return 0.5 } }

    
    // MARK: regular fonts
    var smallFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextRegular, size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)} }
    var defaultFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextRegular, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)} }
    var mediumFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)} }
    var headerFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextRegular, size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)} }
    var extraLargeFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextRegular, size: 36.0) ?? UIFont.systemFont(ofSize: 36.0)} }
    
 
    // MARK: medium fonts
    var smallMediumFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextMedium, size: 10.0) ?? UIFont.systemFont(ofSize: 10.0, weight: .medium) } }
    var defaultMediumFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextMedium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .medium) } }
    var mediumMediumFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextMedium, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .medium) } }
    var headerMediumFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextMedium, size: 20.0) ?? UIFont.systemFont(ofSize: 20.0, weight: .medium) } }
    var extraLargeMediumFont: UIFont { return UIFont.init(name: FontConstant.SFProTextMedium, size: 36.0) ?? UIFont.systemFont(ofSize: 36.0, weight: .medium) }
    

    
    // MARK: bold fonts
    var smallBoldFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 10.0) ?? UIFont.systemFont(ofSize: 10.0, weight: .bold) } }
    var defaultBoldFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0, weight: .bold) } }
    var mediumBoldFont14: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .bold) } }
    var mediumBoldFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .bold) } }
    var headerBoldFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 23.0) ?? UIFont.systemFont(ofSize: 23.0, weight: .bold) } }
    var extraLargeBoldFont: UIFont { get { return UIFont.init(name: FontConstant.SFProTextBold, size: 36.0) ?? UIFont.systemFont(ofSize: 36.0, weight: .bold) } }
    

    var longAnimationDuration: TimeInterval { return 1.0 }
    var mediumAnimationDuration: TimeInterval { return 0.5 }
    var quickAnimationDuration: TimeInterval { return 0.25}

    var gridCellToScreenRatio: CGFloat { get { return 0.35 } }
    var carouselCellWidthToScreenRatio: CGFloat { get { return 0.6 } }
    var carouselCellHeightToScreenRatio: CGFloat { get { return 0.25 } }
    
    var splashBgColor1: UIColor {
        get { return UIColor(hex: "fdd251")}
    }
    
    var splashBgColor2: UIColor {
        get { return UIColor(hex: "37c785")}
    }
    
    var splashBgColor3: UIColor {
        get { return UIColor(hex: "2cb4f6")}
    }
    
    var facebookColor: UIColor {
        get { return UIColor(hex: "3B5998")}
    }
    
    var textColor: UIColor {
        get { return UIColor(hex: "111111") }
    }
    
    var altTextColor: UIColor {
        get { return .white }
    }
    
    var placeHolderColor: UIColor {
        get { return UIColor(hex: "CDCDCD") }
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
    
    // error color
    var errorColor: UIColor {
        get { return UIColor(hex: "F20441") }
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
    
    var darkBlurEffectView: UIVisualEffectView {
        get { return UIVisualEffectView(effect: UIBlurEffect(style: .dark)) }
    }
    
    var lightBlurEffectView: UIVisualEffectView {
        get { return UIVisualEffectView(effect: UIBlurEffect(style: .light)) }
    }
}

