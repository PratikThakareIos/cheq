//
//  RequestForBankViewModel.swift
//  Cheq
//
//  Created by Amit.Rawal on 27/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import PromiseKit

class RequestForBankViewModel {
   
    var strComment: String = ""
    
//    /v1/Reviews
    
//    {
//      "type": "OnboardingBanklinking",
//      "rating": "Happy",
//      "feedback": "string",
//      "submittedToPlayStore": true
//    }
    
    func postReview()->Promise<Void> {        
        let req = PostReviewRequest.init(type: .onboardingBanklinking, rating: nil, feedback: strComment, submittedToPlayStore: false)
        return Promise<Void>() { resolver in
            CheqAPIManager.shared.postReview(req:req).done { _ in
                resolver.fulfill(())
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func validateInput()->ValidationError? {
        if strComment == "" {
            return ValidationError.allFieldsMustBeFilled
        }
        return nil
    }
}
