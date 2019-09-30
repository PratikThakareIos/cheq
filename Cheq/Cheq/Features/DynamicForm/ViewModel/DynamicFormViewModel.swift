//
//  DynamicFormViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 19/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import MobileSDK

enum DynamicFormTextFieldType {
    case text
    case password
    case checkBox
    case confirmButton
    case spacer
}

struct DynamicFormInput {
    let type: DynamicFormTextFieldType
    let title: String
    let value: String
    
    init (type: DynamicFormTextFieldType, title: String, value: String = "") {
        self.type = type
        self.title = title
        self.value = value
    }
}

class DynamicFormViewModel: BaseViewModel {
    
    var coordinator: DynamicFormViewModelCoordinator = LinkAccountsCoordinator()
    var formModel: InstitutionCredentialsFormModel?
}
