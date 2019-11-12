//
//  BarViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum BarViewState {
    case active
    case nonActive
}

class BarViewModel {
    var amount: Double = 0.0
    var label: String = ""
    var barBackground: UIColor = .clear
    var barTintStartColor: UIColor = AppConfig.shared.activeTheme.gradientSet4.first ?? .cyan
    var barTintEndColor: UIColor = AppConfig.shared.activeTheme.gradientSet4.last ?? .cyan
    var progress: CGFloat = 0.5
    var barWidth: CGFloat = AppConfig.shared.screenWidth() * 0.05
    var barViewState: BarViewState = .nonActive
}
