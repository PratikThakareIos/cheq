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
    case uber = "Uber"
    case deliveroo = "Deliveroo"
    case uberEats = "Uber eats"
    case menulog = "Menulog"
    case ola = "Ola"
    case bolt = "Bolt"
    case airTasker = "Air tasker"
    case other = "Other"
    
    init(fromRawValue: String) {
        self = OnDemandType(rawValue: fromRawValue) ?? .uber
    }
}

struct OnDemandCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.employmentDetails.rawValue
    var questionTitle = "What On demand company are you work for?"
    var coordinatorType: MultipleChoiceQuestionType = .onDemand
    
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let uberEats = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uberEats.rawValue, caption: nil, image: nil, ordering: 0, ref : nil)
            let deliveroo = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.deliveroo.rawValue, caption: nil, image: nil, ordering: 1, ref : nil)
            let menulog = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.menulog.rawValue, caption: nil, image: nil, ordering: 2, ref : nil)
            let uber = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uber.rawValue, caption: nil, image: nil, ordering: 3, ref : nil)
            let ola = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.ola.rawValue, caption: nil, image: nil, ordering: 4, ref : nil)
             let bolt = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.bolt.rawValue, caption: nil, image: nil, ordering: 4, ref : nil)
              let airtasker = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.airTasker.rawValue, caption: nil, image: nil, ordering: 4, ref : nil)
              let other = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.other.rawValue, caption: nil, image: nil, ordering: 4, ref : nil)
            let result = [uber, deliveroo,uberEats, menulog,ola,bolt,airtasker,other]
            resolver.fulfill(result)
        }
    }
    

}
