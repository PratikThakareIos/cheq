//
//  CBATheme.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 11/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

struct DarkTheme: AppThemeProtocol {
    var themeTitle: String { get { return "DarkTheme" } }
    var gridCellToScreenRatio: CGFloat { get { return 0.35 } }
    var carouselCellWidthToScreenRatio: CGFloat { get { return 0.6 } }
    var carouselCellHeightToScreenRatio: CGFloat { get { return 0.25 } }
}

//MARK: colors
extension DarkTheme {
    var gradientSet1: [UIColor] {
        get {
            return [alternativeColor1, alternativeColor2]
        }
    }

    var gradientSet2: [UIColor] {
        get {
            return [alternativeOrangeColor, alternativeYellowColor]
        }
    }
    var gradientSet3: [UIColor] {
        get {
            return [alternativeColor3, alternativeColor4]
        }
    }

    var primaryColor: UIColor {
        get { return UIColor(hex: "FFFFFF") }
    }

    var alternativeColor1: UIColor {
        get { return UIColor(hex: "64E1F5") }
    }

    var alternativeColor2: UIColor {
        get { return UIColor(hex: "6BFF9F") }
    }

    var alternativeColor3: UIColor {
        get { return UIColor(hex: "7888FF") }
    }

    var alternativeColor4: UIColor {
        get { return UIColor(hex: "CA7BF4") }
    }

    var alternativeOrangeColor: UIColor {
        get { return UIColor(hex: "FF8C3B")}
    }

    var alternativeYellowColor: UIColor {
        get { return UIColor(hex: "FFFD68")}
    }

    var backgroundColor: UIColor {
        get { return UIColor(hex: "000000") }
    }

    var textBackgroundColor: UIColor {
        get { return UIColor(hex: "000000")}
    }

    var textColor: UIColor {
        get { return .white }
    }

    var linksColor: UIColor {
        get { return alternativeColor3 }
    }

    var nonActiveAlpha: CGFloat { get { return 0.5 } }

    var barStyle: UIBarStyle { get { return .black } }
}

//MARK: fonts
extension DarkTheme {
    var defaultFont: UIFont {
        get { return UIFont.systemFont(ofSize: 12.0)}
    }

    var mediumFont: UIFont {
        get { return UIFont.systemFont(ofSize: 15.0)}
    }

    var headerFont: UIFont {
        get { return UIFont.systemFont(ofSize: 20.0)}
    }
}

//MARK: animation variables
extension DarkTheme {
    var longAnimationDuration: TimeInterval { return 1.0 }
    var mediumAnimationDuration: TimeInterval { return 0.5 }
    var quickAnimationDuration: TimeInterval { return 0.25}
}
