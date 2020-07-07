//
//  QuestionPickerViewCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
//import MobileSDK

enum MaritalStatus: String {
    case single = "Single"
    case couple = "Couple"
}

class QuestionPickerViewCoordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
//    static let maritalStatus = [PutUserDetailRequest.MaritalStatus.single, PutUserDetailRequest.MaritalStatus.couple]
    static let maritalStatus:[MaritalStatus] = [.single, .couple]
    static let dependents = ["0", "1", "2", "3", "4", "5+"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let cPicker = pickerView as? CPickerView else { return 0 }
        switch cPicker.field {
        case .maritalStatus, .dependents:
            return 1
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let cPicker = pickerView as? CPickerView else { return 0 }
        switch cPicker.field {
        case .maritalStatus:
            return QuestionPickerViewCoordinator.maritalStatus.count
        case .dependents:
            return QuestionPickerViewCoordinator.dependents.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let cPicker = pickerView as? CPickerView else { return nil }
        switch cPicker.field {
            case .maritalStatus:
                let status = QuestionPickerViewCoordinator.maritalStatus[row]
                return status.rawValue
            case .dependents:
                return QuestionPickerViewCoordinator.dependents[row]
            default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cPicker = pickerView as? CPickerView else { return }
        switch cPicker.field {
            case .maritalStatus:
                let status = QuestionPickerViewCoordinator.maritalStatus[row]
                LoggingUtil.shared.cPrint("\(status) selected")
                NotificationUtil.shared.notify(QuestionField.maritalStatus.rawValue, key: "selected", value: status.rawValue)
            case .dependents:
                let dependents = QuestionPickerViewCoordinator.dependents[row]
                NotificationUtil.shared.notify(QuestionField.dependents.rawValue, key: "selected", value: dependents)
            default: return
        }
    }
}
