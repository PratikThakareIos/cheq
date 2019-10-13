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

class CompleteDetailsTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "CompleteDetailsTableViewCell"
    var type: CompleteDetailsType = .workDetails
    var expanded: Bool = false 

    func imageIcon()-> String {
        switch type {
        case .bankDetils: return "InfoIcon"
        case .workDetails: return "InfoIcon"
        case .verifyYourDetails: return "InfoIcon"
        }
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
