//
//  MoneySoftEndpointsProd.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

struct MoneySoft {
    static let API_BASE_URL = "https://api.moneysoft.com.au"
    static let API_REFERRER = "https://cheq.moneysoft.com.au"
    static let config = MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: false, isBeta: false, aggregationTimeout: 600)
    
    static let bgTaskConfig = MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: false, isBeta: false, aggregationTimeout: 60)
}
