//
//  DeclineViewTestUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

/**
 Helper class to generate DeclineDetails for testing purpose
 */
class DeclineViewTestUtil {
    
    /// Singleton instance
    static let shared = DeclineViewTestUtil()
    /// private init for implementing Singleton
    private init() {}
    
    /// Helper method to generate decline details with a given **DeclineDetail.DeclineReason**
    func generateDeclineDetails(_ reason: DeclineDetail.DeclineReason)-> DeclineDetail? {
        switch reason {
        case ._none:
            return nil
        default:
            let declineDetails = generateDeclineDetails(reason)
            return declineDetails
        }
    }
}
