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
    let bgColor: UIColor
    let imageName: String
    let gradientColors: [UIColor]
}

class SplashViewModel: BaseViewModel {

    let benefitList: [Benefit] = { ()-> [Benefit] in
        let benefit1 = Benefit(title: "Go to work", caption: "Same day pay can only be used if you physically go to work", bgColor: AppConfig.shared.activeTheme.alternativeColor2, imageName: "emoji01", gradientColors: AppConfig.shared.activeTheme.gradientSet1)
        let benefit2 = Benefit(title: "Request your pay in advance", caption: "When you finish work for the day you can access a portion of your pay instantly deposited into your bank account - lightning fast", bgColor: AppConfig.shared.activeTheme.alternativeColor4, imageName: "emoji02", gradientColors: AppConfig.shared.activeTheme.gradientSet2)
        let benefit3 = Benefit(title: "Easy payback", caption: "You get paid from your work as per usual. and we automatically deduct the pay advances you requested plus a minimal transaction fee. No interest, no hidden costs", bgColor: AppConfig.shared.activeTheme.alternativeColor3, imageName: "emoji03", gradientColors: AppConfig.shared.activeTheme.gradientSet3)
        return [benefit1, benefit2, benefit3]
    }()
    
    func load(_ complete: @escaping ()->Void) {
        complete()
    }
}
