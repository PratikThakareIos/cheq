//
//  CompleteDetailsTableViewCellViewModel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// There are 4 (for now three implemented)  stages of completing details on enabling Lending. The titles are keep within CompleteDetailsType enum constants
enum CompleteDetailsType: String {
    case workDetails = "Employement details"
    case workVerify = "Veryfy that you have worked"
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
    static var turnOnlocation = false
    /// Type of **CompleteDetailsType**
    var type: CompleteDetailsType = .workDetails
       /// Type of **userAction Object**
    var userAction: UserAction.Action = .turnOnLocation
    /// State of this "Complete Details Stage"
    var completionState: CompleteDetailsState = .pending
    
    var captionForVarifyWork:String?
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
        case .inprogress: return "DetailsInprogress"
        }
        switch type {
        case .bankDetils:
            filename = "bankDetails"
        case .workDetails:
            filename = "workDetails"
        case .verifyYourDetails:
            filename = "identityVerification"
        case .workVerify:
            filename = "workVerify"
        }
        
        /// the image file name is constructed through combination of the two attributes
        return String(describing: "\(filename)\(suffix)")
    }

    func showTurnonLocationButton() -> Bool {
        return userAction == .turnOnLocation ? true:false
    }
    
    func verifyWorkImage() -> String {
        switch userAction {
        case .resolveNameConflict:
            return "car"
        case .turnOnLocation:
             return "carInactive"
        case .turnupToWork:
            return "car"
        case .uploadRecentTimesheet:
            return "uploadTimesheet"
            
        }
        
    }
    
    
    func linkButtonText() -> String {
        switch userAction {
        case .resolveNameConflict:
            return "How does it work?"
        case .turnOnLocation:
             return "How does it work?"
        case .turnupToWork:
            return "How does it work?"
        case .uploadRecentTimesheet:
           return "Timesheet guidlines"
            
        }
       
    }
    
    func setWorkVerifyRoundedButtonTitle() -> String {
        switch userAction {
        case .resolveNameConflict:
            return ""
        case .turnOnLocation:
             return "Turn on location"
        case .turnupToWork:
            return ""
        case .uploadRecentTimesheet:
           return "Upload recent timesheet"
            
        }
       
    }
    func showSecondaryButton() -> Bool {
        switch userAction {
        case .resolveNameConflict:
            return true
        case .turnOnLocation:
             return false
        case .turnupToWork:
            return true
        case .uploadRecentTimesheet:
           return false
            
        }
       
    }

    /// headerText method that returns text corresponding to the **CompleteDetailsType** and **CompleteDetailsState**
    func headerText()-> String {
        switch type {
        case .bankDetils: return "Enter your bank details"
        case .workDetails: return "Employment details"
        case .workVerify: return "Verify that you've worked"
        case .verifyYourDetails:
            let header = (self.completionState == CompleteDetailsState.inprogress) ?  "Verifying your identity..." : "Verify your identity"
            return header
        }
    }


    
    /// detailsText method that returns text corresponding to the **CompleteDetailsType** and **CompleteDetailsState**
    func detailsText()-> String {
        switch type {
        case .bankDetils: return "Add your bank details for a faster repayment."
        case .workDetails: return "Complete your employment details to ensure you're eligible for same day pay."
        case .workVerify:
            //Set the parameters from UserAction
            guard let caption = captionForVarifyWork else {
                return "You don't have to do anything just turn up to work. Once you have a sufficient number of hours you will unlock up to $300 pay cycle"
            }
            return caption
        case .verifyYourDetails:
            let details = (self.completionState == CompleteDetailsState.inprogress) ? "This usually takes less than 2 minutes, but can take up to 48 hours." : "Complete your details for identity verification."
            return details
        
        }
    }
}
