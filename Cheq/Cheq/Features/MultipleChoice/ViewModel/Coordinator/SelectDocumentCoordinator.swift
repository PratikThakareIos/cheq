//
//  SelectDocumentCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum KycDocType: String, CaseIterable {
    case passport = "Passport"
    case driversLicense = "Driver license"
    case medicareCard = "Medicare Card"

    init(fromRawValue: String) {
        self = KycDocType(rawValue: fromRawValue) ?? .passport
    }
}

class SelectDocumentCoordinator: MultipleChoiceViewModelCoordinator {
    
    var sectionTitle = Section.verifyMyIdentity.rawValue
    
    var questionTitle = "Select a document"
    
    var coordinatorType: MultipleChoiceQuestionType = .kycSelectDoc
    
    func choices()-> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let choices = [selectDocToChoiceModel(.passport), selectDocToChoiceModel(.driversLicense)]
            resolver.fulfill(choices)
        }
    }
}

extension SelectDocumentCoordinator {
    func selectDocToChoiceModel(_ type: KycDocType)->ChoiceModel {
        return ChoiceModel(type: .choiceWithCaption, title: type.rawValue, caption: "", image: nil, ordering: 0, ref: type)
    }
}
