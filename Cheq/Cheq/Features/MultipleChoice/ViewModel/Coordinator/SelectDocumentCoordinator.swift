//
//  SelectDocumentCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum KycDocType: String {
    case Passport = "Passport"
    case DriversLicense = "Driver's license"
    
    init(fromRawValue: String) {
        self = KycDocType(rawValue: fromRawValue) ?? .Passport
    }
}

class SelectDocumentCoordinator: MultipleChoiceViewModelCoordinator {
    
    var sectionTitle = Section.verifyMyIdentity.rawValue
    
    var questionTitle = "Select a document"
    
    var coordinatorType: MultipleChoiceQuestionType = .kycSelectDoc
    
    func choices()-> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let choices = [selectDocToChoiceModel(.Passport), selectDocToChoiceModel(.DriversLicense)]
            resolver.fulfill(choices)
        }
    }
}

extension SelectDocumentCoordinator {
    func selectDocToChoiceModel(_ type: KycDocType)->ChoiceModel {
        return ChoiceModel(type: .choiceWithCaption, title: type.rawValue, caption: "", image: nil, ref: type)
    }
}
