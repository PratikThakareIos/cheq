//
//  CompleteDetailsTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum CompleteDetailsType: String {
    case workDetails = "Work details"
    case bankDetils = "Enter your bank details"
    case verifyYourDetails = "Verify your identity"

    init(fromRawValue: String){
        self = CompleteDetailsType(rawValue: fromRawValue) ?? .workDetails
    }
}

enum CompleteDetailsState: String {
    case inactive = "Inactive"
    case pending = "Pending"
    case done = "Done"
    
    init(fromRawValue: String) {
        self = CompleteDetailsState(rawValue: fromRawValue) ?? .inactive
    }
}

class CompleteDetailsTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "CompleteDetailsTableViewCell"
    var type: CompleteDetailsType = .workDetails
    var completionState: CompleteDetailsState = .pending
    var expanded: Bool = false 

    func imageIcon()-> String {
        var filename = ""
        var suffix = ""
        switch completionState {
        case .done: return "DetailsSuccess"
        case .inactive:
            suffix = "Inactive"
        case .pending:
            suffix = "Pending"
        }
        switch type {
        case .bankDetils:
            filename = "bankDetails"
        case .workDetails:
            filename = "workDetails"
        case .verifyYourDetails:
            filename = "identityVerification"
        }
        
        return String(describing: "\(filename)\(suffix)")
    }

    func headerText()-> String {
        switch type {
        case .bankDetils: return "Enter your bank details"
        case .workDetails: return "Working details"
        case .verifyYourDetails: return "Verify your identity"

        }
    }

    func detailsText()-> String {
        switch type {
        case .bankDetils: return "Link your banking details to ensure you're eligible for same day pay."
        case .workDetails: return "Complete your employment details to ensure you're eligible for same day pay."
        case .verifyYourDetails: return "Complete your details for identity verification."
        }
    }
}
