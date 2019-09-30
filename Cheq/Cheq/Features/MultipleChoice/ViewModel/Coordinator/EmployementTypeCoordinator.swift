//
//  EmployementTypeCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum EmploymentType: String {
    case fulltime = "Full time"
    case onDemand = "On demand"
    case contract = "Contractual"
    case casual = "Casual employee"
    case selfEmployed = "Self employed"
    case partTime = "Part time"
    
    init(fromRawValue: String) {
        self = EmploymentType(rawValue: fromRawValue) ?? .fulltime
    }
}

struct EmployementTypeCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.employmentDetails.rawValue
    var questionTitle = "Employment type"
    var coordinatorType: MultipleChoiceQuestionType = .employmentType
    
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let fullTime = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.fulltime.rawValue, caption: "Full time description and example", image: nil, ref : nil)
            let onDemand = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.onDemand.rawValue, caption: "On demand description", image: nil, ref : nil)
            let contractual = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.contract.rawValue, caption: "Contractors", image: nil, ref : nil)
            let casual = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.casual.rawValue, caption: "Casual employment", image: nil, ref : nil)
            let selfEmployed = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.selfEmployed.rawValue, caption: "Self employed", image: nil, ref : nil)
            let partTime = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.partTime.rawValue, caption: "Part time", image: nil, ref : nil)
            let result = [fullTime, onDemand, contractual, casual, partTime, selfEmployed]
            resolver.fulfill(result)
        }
    }
    

}
