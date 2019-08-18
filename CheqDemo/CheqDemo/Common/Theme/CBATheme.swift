//
//  CBATheme.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 11/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

struct CBATheme: AppThemeProtocol {

// AppThemeProtocol extension can take of other implementations
//MARK: colors
    var themeTitle: String {
        get { return "CommonWealth Bank" }
    }

    var barStyle: UIBarStyle { get { return .default } }
    var textColor: UIColor { get { return UIColor(hex: "000000") } }
    var linksColor: UIColor { get { return UIColor(hex: "40AEFF") } }
    var primaryColor: UIColor { get { return UIColor(hex: "FFCC00") } }
    var backgroundColor: UIColor { get { return UIColor(hex: "FFFFFF") } }
    var textBackgroundColor: UIColor { get { return UIColor(hex: "FFFFFF") } }
    var alternativeColor1: UIColor { get { return UIColor(hex: "FFCC00") } }
    var alternativeColor2: UIColor { get { return UIColor(hex: "FFCC00") } }
    var alternativeColor3: UIColor { get { return UIColor(hex: "FFCC00") } }
    var alternativeColor4: UIColor { get { return UIColor(hex: "FFCC00") } }

    var gradientSet1: [UIColor] {
        get {
            return [primaryColor, alternativeColor2]
        }
    }

    var gradientSet2: [UIColor] {
        get {
            return [primaryColor, alternativeColor3]
        }
    }
    var gradientSet3: [UIColor] {
        get {
            return [primaryColor, alternativeColor4]
        }
    }
}
