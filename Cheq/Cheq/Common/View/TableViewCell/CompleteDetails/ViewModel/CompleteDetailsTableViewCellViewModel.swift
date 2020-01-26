//
//  CompleteDetailsTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// There are 3 stages of completing details on enabling Lending. The titles are keep within CompleteDetailsType enum constants
enum CompleteDetailsType: String {
    case workDetails = "Work details"
    case bankDetils = "Enter your bank details"
    case verifyYourDetails = "Verify your identity"

    /// allowing the enum to be initialise from rawValue
    init(fromRawValue: String){
        self = CompleteDetailsType(rawValue: fromRawValue) ?? .workDetails
    }
}

/// The complete details stages can potentially have 4 different states UI, **CompleteDetailsState** is representation for these states
enum CompleteDetailsState: String {
    case inactive = "Inactive"
    case pending = "Pending"
    case done = "Done"
    case inprogress = "Inprogress"
    
    /// allowing the enum to be initialise from rawValue
    init(fromRawValue: String) {
        self = CompleteDetailsState(rawValue: fromRawValue) ?? .inactive
    }
}

/**
 ViewModel for **CompleteDetailsTableViewCell**. Each **CompleteDetailsTableViewCell** represents a row in the complet details stages item list. Check Lending screen UI.
 */
class CompleteDetailsTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// Reuse identifier
    var identifier: String = "CompleteDetailsTableViewCell"
    
    /// Type of **CompleteDetailsType**
    var type: CompleteDetailsType = .workDetails
    
    /// State of this "Complete Details Stage"
    var completionState: CompleteDetailsState = .pending
    
    /// Complete details can be expanded or compressed, this is the toggle that drives the UI state
    var expanded: Bool = false 

    /// imageIcon method returns the image name for the icon corresponding to the "Complete Details" **CompleteDetailsType** and **CompleteDetailsState**
    func imageIcon()-> String {
        var filename = ""
        var suffix = ""
        switch completionState {
        case .done: return "DetailsSuccess"
        case .inactive:
            suffix = "Inactive"
        case .pending:
            suffix = "Pending"
        case .inprogress:
            suffix = "Inactive"
        }
        switch type {
        case .bankDetils:
            filename = "bankDetails"
        case .workDetails:
            filename = "workDetails"
        case .verifyYourDetails:
            filename = "identityVerification"
        }
        
        /// the image file name is constructed through combination of the two attributes
        return String(describing: "\(filename)\(suffix)")
    }

    /// headerText method that returns text corresponding to the **CompleteDetailsType** and **CompleteDetailsState**
    func headerText()-> String {
        switch type {
        case .bankDetils: return "Enter your bank details"
        case .workDetails: return "Working details"
        case .verifyYourDetails:
            let header = (self.completionState == CompleteDetailsState.inprogress) ?  "Verifying your identity..." : "Verify your identity"
            return header

        }
    }

    /// detailsText method that returns text corresponding to the **CompleteDetailsType** and **CompleteDetailsState**
    func detailsText()-> String {
        switch type {
        case .bankDetils: return "Link your banking details to ensure you're eligible for same day pay."
        case .workDetails: return "Complete your employment details to ensure you're eligible for same day pay."
        case .verifyYourDetails:
            let details = (self.completionState == CompleteDetailsState.inprogress) ? "This usually takes less than 2 minutes, but can take up to 48 hours." : "Complete your details for identity verification."
            return details
        }
    }
}
