//
//  MultipleChoiceViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import MobileSDK

enum MultipleChoiceQuestionType: String {
    case employmentType = "Employment type"
    case onDemand = "On Demand"
    case financialInstitutions = "Financial Institutions"
    case ageRange = "Age Range"
    case state = "State"
    case kycSelectDoc = "Select a document"
}

enum ChoiceType {
    case choiceWithCaption
    case choiceWithIcon
}

struct ChoiceModel: Equatable {
    let type: ChoiceType
    let title: String
    let caption: String?
    let image: String?
    let ordering: Int
    var ref: Any? = nil
    
    static func == (lhs: ChoiceModel, rhs: ChoiceModel) -> Bool {
        return lhs.type == rhs.type &&
                lhs.title == rhs.title &&
                lhs.caption == rhs.caption &&
                lhs.image == rhs.image &&
                lhs.ordering == rhs.ordering
    }
}

class MultipleChoiceViewModel: BaseViewModel {
    var coordinator: MultipleChoiceViewModelCoordinator = EmployementTypeCoordinator()
    var savedAnswer: [String: String] = [:]
    
    override init() {
        super.init()
        self.load()
    }
    
    func question()-> String {
        return coordinator.questionTitle
    }
}

extension MultipleChoiceViewModel {
    func viewModelKey()-> String {
        return QuestionViewModel().viewModelKey()
    }
    
    func save(_ key: String, value: String) {
        if self.savedAnswer.count == 0 { load() }
        savedAnswer[key] = value
        self.save()
    }
    
    func save() {
        UserDefaults.standard.set(savedAnswer, forKey: self.viewModelKey())
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        guard let existing = UserDefaults.standard.value(forKey: self.viewModelKey()) as? Dictionary<String,String> else {
            self.savedAnswer = [:]
            return
        }

        self.savedAnswer = existing
    }
}

extension MultipleChoiceViewModel {
    static func coordinatorfor(_ multipleChoiceType: MultipleChoiceQuestionType)->MultipleChoiceViewModelCoordinator {
        switch multipleChoiceType {
        case .employmentType:
            return EmployementTypeCoordinator()
        case .onDemand:
            return  OnDemandCoordinator()
        case .financialInstitutions:
            return FinancialInstitutionCoordinator()
        case .ageRange:
            return AgeRangeCoordinator()
        case .state:
            return StateCoordinator()
        case .kycSelectDoc:
            return SelectDocumentCoordinator()
        }
    }
}

extension MultipleChoiceViewModel {
    static func cheqAPIEmploymentType(_ type: EmploymentType)-> PutUserEmployerRequest.EmploymentType {
        switch type {
        case .fulltime:
            return PutUserEmployerRequest.EmploymentType.fulltime
        case .casual:
            return PutUserEmployerRequest.EmploymentType.casual
        case .onDemand:
            return PutUserEmployerRequest.EmploymentType.onDemand
        case .contract:
            return PutUserEmployerRequest.EmploymentType.contractor
        case .selfEmployed:
            return PutUserEmployerRequest.EmploymentType.selfEmployed
        case .partTime:
            return PutUserEmployerRequest.EmploymentType.parttime
        }
    }
}
