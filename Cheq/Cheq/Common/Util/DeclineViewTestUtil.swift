//
//  DeclineViewTestUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 18/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class DeclineViewTestUtil {
    static let shared = DeclineViewTestUtil()
    private init() {}
    
    func generateDeclineDetails(_ reason: DeclineDetail.DeclineReason)-> DeclineDetail? {
        switch reason {
        case ._none:
            return nil
        default:
            let declineDetails = DeclineDetail(declineReason: reason, declineDescription: TestUtil.shared.randomString(500))
            return declineDetails
        }
    }
}
