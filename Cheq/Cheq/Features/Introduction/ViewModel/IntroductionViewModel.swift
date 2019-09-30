//
//  IntroductionViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum IntroductionType: String {
    case email = "Check your email"
    case employee = "Employee details"
    case setupBank = "Set up your bank"
    case enableLocation = "Enable location"
    case notification = "Notification"
    case verifyIdentity = "Verify your identity"
}

class IntroductionViewModel: BaseViewModel {
    var type: IntroductionType = .email
    
    func caption()-> String {
        switch type {
        case .email:
            return "We sent an email to you at xuwei@cheq.com.au. It has a link that'll activate your account"
        case .employee:
            return "Please provide us your employment details"
        case .setupBank:
            return "Please provide us your bank details"
        case .enableLocation:
            return "Please enable location for our app"
        case .notification:
            return "Please enable notification for our app"
        case .verifyIdentity:
            return "Please proceed with our identity verification flow"
        }
    }
    
//     case .setupBank, .email, .enableLocation, .notification, .verifyIdentity:
    func confirmButtonTitle()-> String {
        switch type {
        case .setupBank:
            return "Setup your bank"
        case .email:
            return "Open mail app"
        case .enableLocation:
            return "Turn on location"
        case .notification:
            return "Allow push notification"
        case .verifyIdentity:
            return "Verify"
        case .employee:
            return "Setup your work details"
        }
    }
    
    func nextButtonTitle()-> String {
        switch type {
        case .setupBank:
            return "Learn more"
        case .email:
            return "Close"
        case .enableLocation:
            return "Not now"
        case .notification:
            return "Not now"
        case .verifyIdentity:
            return "Not now"
        case .employee:
            return "Not now"
//        default: return ""
        }
    }
    
    func imageName()-> String {
        switch type {
        case .email:
            return "email"
        case .employee:
            return "work"
        case .enableLocation:
            return "location"
        case .verifyIdentity:
            return "verifyIdentity"
        case .notification:
            return "notification"
        case .setupBank:
            return "bank"
        }
    }
    
    func header()-> String {
        return self.type.rawValue
    }
}
