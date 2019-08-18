//
//  AppConfig.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import SwiftSpinner

let sharedAppConfig = AppConfig()

// manages the app global variables
class AppConfig {
    var themeTitles = [PrimaryTheme().themeTitle, DarkTheme().themeTitle, CBATheme().themeTitle]
    var themes:[AppThemeProtocol] = [PrimaryTheme(), DarkTheme(), CBATheme()]
    var activeTheme: AppThemeProtocol = PrimaryTheme()
    var currentActiveThemeIndex = 0

    func switchTheme(_ index: Int) {
        guard index >= 0, index < themes.count else { return }
        self.currentActiveThemeIndex = index
        activeTheme = themes[currentActiveThemeIndex]
    }

    func showSpinner() {
        SwiftSpinner.setTitleFont(activeTheme.headerFont)
        SwiftSpinner.setTitleColor(activeTheme.alternativeColor1)
        SwiftSpinner.setAnimationDelay(activeTheme.quickAnimationDuration)
        SwiftSpinner.show("Loading", animated: true)
    }

    func hideSpinner() {
        SwiftSpinner.hide()
    }
}
