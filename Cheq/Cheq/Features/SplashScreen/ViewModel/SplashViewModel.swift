//
//  LoginViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 7/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import PromiseKit

struct Benefit {
    let title: String
    let caption: String
    let textColor: UIColor
    let bgColor: UIColor
    let imageName: String
    let gradientColors: [UIColor]
}

class SplashViewModel: BaseViewModel {

    let benefitList: [Benefit] = { ()-> [Benefit] in
        let benefit1 = Benefit(title: "Budgeting is hard, we get it!", caption: "Cheq automatically creates your budget, so you don't have to!", textColor: AppConfig.shared.activeTheme.altTextColor, bgColor: AppConfig.shared.activeTheme.alternativeColor2, imageName: "emoji01", gradientColors: AppConfig.shared.activeTheme.gradientSet1)
        let benefit2 = Benefit(title: "Take the guesswork out of spending!", caption: "Cheq tells you what's OK to spend and predicts your upcoming bills.", textColor: AppConfig.shared.activeTheme.altTextColor, bgColor: AppConfig.shared.activeTheme.alternativeColor4, imageName: "emoji04", gradientColors: AppConfig.shared.activeTheme.gradientSet2)
        let benefit3 = Benefit(title: "Get your Pay On demand™", caption: "Say goodbye to paydays and get a portion of your pay instantly!", textColor: AppConfig.shared.activeTheme.textColor, bgColor: AppConfig.shared.activeTheme.alternativeColor3, imageName: "emoji03", gradientColors: AppConfig.shared.activeTheme.gradientSet3)
        return [benefit1, benefit2, benefit3]
    }()
    
    override func load(_ complete: @escaping ()->Void) {
        complete()
    }
}
