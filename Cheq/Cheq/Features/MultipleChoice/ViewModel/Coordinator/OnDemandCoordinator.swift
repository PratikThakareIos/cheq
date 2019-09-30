//
//  OnDemandCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum OnDemandType: String {
    case uberEats = "Uber eats"
    case deliveroo = "Deliveroo"
    case menulog = "Menulog"
    case uber = "Uber"
    case other = "Other"
    
    init(fromRawValue: String) {
        self = OnDemandType(rawValue: fromRawValue) ?? .other
    }
}

struct OnDemandCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.employmentDetails.rawValue
    var questionTitle = "On Demand Employer"
    var coordinatorType: MultipleChoiceQuestionType = .onDemand
    
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let uberEats = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uberEats.rawValue, caption: nil, image: nil, ref : nil)
            let deliveroo = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.deliveroo.rawValue, caption: nil, image: nil, ref : nil)
            let menulog = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.menulog.rawValue, caption: nil, image: nil, ref : nil)
            let uber = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uber.rawValue, caption: nil, image: nil, ref : nil)
            let other = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.other.rawValue, caption: nil, image: nil, ref : nil)
            let result = [uberEats, deliveroo, menulog, uber, other]
            resolver.fulfill(result)
        }
    }
    

}
