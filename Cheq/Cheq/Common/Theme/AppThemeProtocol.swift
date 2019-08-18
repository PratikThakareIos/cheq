//
//  AppThemeProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

// by adopting AppThemeProtocol protocol, we can create different ui themes for the app
protocol AppThemeProtocol {

    //MARK: theme info
    var themeTitle: String { get }

    //MARK: fonts
    var defaultFont: UIFont { get }
    var mediumFont: UIFont { get }
    var headerFont: UIFont { get }

    //MARK: colors
    var barStyle: UIBarStyle { get }
    var textColor: UIColor { get }
    var linksColor: UIColor { get }
    var primaryColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var textBackgroundColor: UIColor { get }
    var alternativeColor1: UIColor { get }
    var alternativeColor2: UIColor { get }
    var alternativeColor3: UIColor { get }
    var alternativeColor4: UIColor { get }
    var nonActiveAlpha: CGFloat { get }

    //MARK: gradients
    var gradientSet1: [UIColor] { get }
    var gradientSet2: [UIColor] { get }
    var gradientSet3: [UIColor] { get }
    func allBgColors()-> [UIColor]

    //MARK: animations
    var longAnimationDuration: TimeInterval { get }
    var mediumAnimationDuration: TimeInterval { get }
    var quickAnimationDuration: TimeInterval { get }

    //MARK: styling logics
    var padding: CGFloat { get }
    var gridCellToScreenRatio: CGFloat { get }
    var carouselCellWidthToScreenRatio: CGFloat { get }
    var carouselCellHeightToScreenRatio: CGFloat { get }
    var popoverMenuLabelHeight: CGFloat { get }
    var popoverMenuToScreenWidthRatio: CGFloat { get }

    func cardStyling(_ view: UIView, bgColors: [UIColor])
    func cardStyling(_ view: UIView, bgColor: UIColor)
    func collectionViewPadding(_ collectionView: UICollectionView, cellLength: CGFloat, collectionType: CollectionViewType)
}

// MARK: Styling logics 
extension AppThemeProtocol {

    var popoverMenuLabelHeight: CGFloat { get { return 40.0 } }
    var popoverMenuToScreenWidthRatio: CGFloat { get { return 0.5 } }

    func cardStyling(_ view: UIView, bgColor: UIColor) {
        view.backgroundColor = bgColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20.0
        view.layer.shadowPath =
            UIBezierPath(roundedRect: view.layer.bounds,
                         cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = textColor.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = view.layer.cornerRadius / 2.0
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
        gradientLayer.cornerRadius = 20.0
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

    var longAnimationDuration: TimeInterval { return 1.0 }
    var mediumAnimationDuration: TimeInterval { return 0.5 }
    var quickAnimationDuration: TimeInterval { return 0.25}

    var gridCellToScreenRatio: CGFloat { get { return 0.35 } }
    var carouselCellWidthToScreenRatio: CGFloat { get { return 0.6 } }
    var carouselCellHeightToScreenRatio: CGFloat { get { return 0.25 } }
}
