//
//  StateCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
//import MobileSDK
import PromiseKit

class StateCoordinator: MultipleChoiceViewModelCoordinator {
    
    var sectionTitle = ""
    
    var questionTitle = "What state was your driver's licence issued?"

    var coordinatorType: MultipleChoiceQuestionType = .state
    
    func choices()-> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let choices = cState.allCases.map { self.stateToChoiceModel($0) }
            resolver.fulfill(choices)
        }
    }
}

extension StateCoordinator {
    func stateToChoiceModel(_ state: cState?)-> ChoiceModel {
        return ChoiceModel(type: .choiceWithCaption, title: state?.rawValue ?? "", caption: "", image: nil, ordering: 0, ref : nil)
    }
}
