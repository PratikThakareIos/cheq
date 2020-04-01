//
//  MultipleChoiceViewModelCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum Section: String {
    case aboutMe = "About me"
    case employmentDetails = "Employment Details"
    case bankDetails = "Bank Details"
    case verifyMyIdentity = "Verify Identity"
}

protocol MultipleChoiceViewModelCoordinator {
    var sectionTitle: String { get }
    var questionTitle: String { get }
    var coordinatorType: MultipleChoiceQuestionType { get }
    func choices()->Promise<[ChoiceModel]>
}
