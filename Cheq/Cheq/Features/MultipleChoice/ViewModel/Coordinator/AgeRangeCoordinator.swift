//
//  BirthdayRangeCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

struct AgeRangeCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.aboutMe.rawValue
    var questionTitle = "What is your age range?"
    var coordinatorType: MultipleChoiceQuestionType = .ageRange
    
    func choices() -> Promise<[ChoiceModel]> {
        return ageRanges()
    }
    
    func ageRanges()->Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let choices = [ageRangeToChoiceModel(.from18To24), ageRangeToChoiceModel(.from25To34), ageRangeToChoiceModel(.from35To54), ageRangeToChoiceModel(.from55To64), ageRangeToChoiceModel(.over65)]
            resolver.fulfill(choices)
        }
    }
}

extension AgeRangeCoordinator {
    func ageRangeToChoiceModel(_ ageRange: PutUserDetailRequest.AgeRange)-> ChoiceModel {
        switch ageRange {
        case .from18To24:
            return ChoiceModel(type: .choiceWithIcon, title: "Aged 18 to 24", caption: "", image: nil, ordering: 0, ref: nil)
        case .from25To34:
            return ChoiceModel(type: .choiceWithIcon, title: "Aged 25 to 34", caption: "", image: nil, ordering: 0, ref: nil)
        case .from35To54:
            return ChoiceModel(type: .choiceWithIcon, title: "Aged 35 to 54", caption: "", image: nil, ordering: 0, ref: nil)
        case .from55To64:
            return ChoiceModel(type: .choiceWithIcon, title: "Aged 55 to 64", caption: "", image: nil, ordering: 0, ref: nil)
        case .over65:
            return ChoiceModel(type: .choiceWithIcon, title: "Aged 65 and over", caption: "", image: nil, ordering: 0, ref: nil)
        }
    }
    
    static func ageRangeToPutUserDetailsReqAgeRange(_ ageRange: String)-> PutUserDetailRequest.AgeRange {
        let range = cAgeRange(fromRawValue: ageRange)
        switch range {
        case .age18to24:
            return .from18To24
        case .age25to34:
            return .from25To34
        case .age35to54:
            return .from35To54
        case .age55To64:
            return .from55To64
        case .over65:
            return .over65
        }
    }
}
