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
    case employmentDetails = "Employment details"
    case bankDetails = "Bank details"
    case verifyMyIdentity = "Verify identity"
}

protocol MultipleChoiceViewModelCoordinator {
    var sectionTitle: String { get }
    var questionTitle: String { get }
    var coordinatorType: MultipleChoiceQuestionType { get }
    func choices()->Promise<[ChoiceModel]>
}
