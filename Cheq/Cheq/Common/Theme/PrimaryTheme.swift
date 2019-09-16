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
    // orange
    var gradientSet1: [UIColor] {
    get {
            return [UIColor(red:1, green:0.63, blue:0.36, alpha:1), UIColor(red:0.99, green:0.47, blue:0.1, alpha:1)]
        }
    }

    // dark pink 
    var gradientSet2: [UIColor] {
        get {
            return [UIColor(red:0.91, green:0.32, blue:0.55, alpha:1), UIColor(red:0.8, green:0.16, blue:0.33, alpha:1)]
        }
    }
    
    // cyan
    var gradientSet3: [UIColor] {
        get {
            return [UIColor(red:0.64, green:0.95, blue:1, alpha:1), UIColor(red:0.42, green:0.89, blue:1, alpha:1)]
        }
    }

    // purple
    var primaryColor: UIColor {
        get { return UIColor(hex: "491556") }
    }

    // purple
    var alternativeColor1: UIColor {
        get { return UIColor(hex: "491556") }
    }

    // orange
    var alternativeColor2: UIColor {
        get { return UIColor(hex: "FF8F40") }
    }

    // light blue
    var alternativeColor3: UIColor {
        get { return UIColor(hex: "6BE4ff") }
    }

    // dark pink
    var alternativeColor4: UIColor {
        get { return UIColor(hex: "DC4277") }
    }

    var alternativeOrangeColor: UIColor {
        get { return UIColor(hex: "FF8C3B")}
    }

    var alternativeYellowColor: UIColor {
        get { return UIColor(hex: "FFFD68")}
    }

    // grayish white
    var backgroundColor: UIColor {
        get { return UIColor(hex: "f4f3f5") }
    }

    // grayish white 
    var textBackgroundColor: UIColor {
        get { return UIColor(hex: "f4f3f5")}
    }

    // text color (black)
    var textColor: UIColor {
        get { return UIColor(hex: "101010") }
    }

    // text links
    var linksColor: UIColor {
        get { return UIColor(hex: "039de1") }
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
