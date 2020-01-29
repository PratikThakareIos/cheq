//
//  GradientView.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 9/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

/**
 Utility method for retrieving random color and random gradient colors
 */
struct ColorUtil {

    /// returns a random "Alternate" color which is still part of activeTheme
    static func randAlternateColor()->UIColor {
        let theme = sharedAppConfig.activeTheme
        let colors = [theme.alternativeColor1, theme.alternativeColor2, theme.alternativeColor3, theme.alternativeColor4]
        return colors.randomElement() ?? theme.alternativeColor1
    }

    /// returns a random gradient set amongst the ones already defined in activeTheme
    static func randGradientSet()->[UIColor] {
        let theme = sharedAppConfig.activeTheme
        let gradients = [theme.gradientSet1, theme.gradientSet3, theme.gradientSet2]
        let randIndex = Int.random(in: 0..<gradients.count) % gradients.count
        let selectedGradient = gradients[randIndex]
        return selectedGradient
    }
    
    // MARK get the hex color to UI colour by passing the hex code
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


