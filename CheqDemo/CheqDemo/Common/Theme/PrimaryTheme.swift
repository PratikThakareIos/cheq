//
//  PrimaryTheme.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 8/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Hex

enum CollectionViewType {
    case carousel, grid
}

// this is an implementation of AppThemeProtocol
// we can create more for different themes. e.g. DarkModeTheme, CBATheme, etc

//MARK: collection styling
struct PrimaryTheme: AppThemeProtocol {
    var themeTitle: String { get { return "PrimaryTheme" } }
    var gridCellToScreenRatio: CGFloat { get { return 0.35 } }
    var carouselCellWidthToScreenRatio: CGFloat { get { return 0.6 } }
    var carouselCellHeightToScreenRatio: CGFloat { get { return 0.25 } }

    func allBgColors()-> [UIColor] {
        return [alternativeColor1, alternativeColor2, alternativeColor3, alternativeColor4, alternativeOrangeColor, alternativeYellowColor]
    }
}

//MARK: colors
extension PrimaryTheme {
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
        get { return UIColor(hex: "0D80FF") }
    }

    var alternativeColor1: UIColor {
        get { return UIColor(hex: "0CAEE8") }
    }

    var alternativeColor2: UIColor {
        get { return UIColor(hex: "01FFFD") }
    }

    var alternativeColor3: UIColor {
        get { return UIColor(hex: "5FE8B1") }
    }

    var alternativeColor4: UIColor {
        get { return UIColor(hex: "55FAFF") }
    }

    var alternativeOrangeColor: UIColor {
        get { return UIColor(hex: "FF8C3B")}
    }

    var alternativeYellowColor: UIColor {
        get { return UIColor(hex: "FFFD68")}
    }

    var backgroundColor: UIColor {
        get { return UIColor(hex: "FFFFFF") }
    }

    var textBackgroundColor: UIColor {
        get { return UIColor(hex: "FFFFFF")}
    }

    var textColor: UIColor {
        get { return .black }
    }

    var linksColor: UIColor {
        get { return alternativeColor3 }
    }
    
    var barStyle: UIBarStyle { get { return .default } }
}

//MARK: fonts
extension PrimaryTheme {
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
extension PrimaryTheme {
    var longAnimationDuration: TimeInterval { return 1.0 }
    var mediumAnimationDuration: TimeInterval { return 0.5 }
    var quickAnimationDuration: TimeInterval { return 0.25}
}
