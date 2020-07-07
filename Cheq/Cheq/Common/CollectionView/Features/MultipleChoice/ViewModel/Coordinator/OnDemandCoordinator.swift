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
    var questionTitle = "What On Demand company are you work for?"
    var coordinatorType: MultipleChoiceQuestionType = .onDemand
    
//    UIImage.init(named: "logo-Ola")
//    UIImage.init(named: "logo-Uber")
//    UIImage.init(named: "logo-UberEats")
//    UIImage.init(named: "logo-AirTasker")
//    UIImage.init(named: "logo-Bolt")
//    UIImage.init(named: "logo-Deliveroo")
//    UIImage.init(named: "logo-Menulog")
//    UIImage.init(named: "navBack")
        
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let uberEats = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uberEats.rawValue, caption: nil, image: "logo-UberEats", ordering: 0, ref : nil)
            let deliveroo = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.deliveroo.rawValue, caption: nil, image: "logo-Deliveroo", ordering: 1, ref : nil)
            let menulog = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.menulog.rawValue, caption: nil, image: "logo-Menulog", ordering: 2, ref : nil)
            let uber = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.uber.rawValue, caption: nil, image: "logo-Uber", ordering: 3, ref : nil)
            let ola = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.ola.rawValue, caption: nil, image: "logo-Ola", ordering: 4, ref : nil)
            let bolt = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.bolt.rawValue, caption: nil, image: "logo-Bolt", ordering: 4, ref : nil)
            let airtasker = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.airTasker.rawValue, caption: nil, image: "logo-AirTasker", ordering: 4, ref : nil)
            let other = ChoiceModel(type: .choiceWithIcon, title: OnDemandType.other.rawValue, caption: nil, image: nil, ordering: 4, ref : nil)
            let result = [uber, deliveroo,uberEats, menulog,ola,bolt,airtasker,other]
            resolver.fulfill(result)
        }
    }
}
