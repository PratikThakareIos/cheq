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
    static let API_REFERRER = "https://pfm.cheq.moneysoft.com.au"
    static func config()-> MoneysoftApiConfiguration {
        let timeout = RemoteConfigManager.shared.remoteNumberValue(RemoteConfigParameters.transactionBoardingTimeoutMins.rawValue)?.intValue ?? 10
        
        return MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: false, isBeta: false, aggregationTimeout: timeout * 60)
    }
    
    static func bgTaskConfig()-> MoneysoftApiConfiguration {
        let timeout = RemoteConfigManager.shared.remoteNumberValue(RemoteConfigParameters.transactionSyncTimeoutMins.rawValue)?.intValue ?? 10
        return MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: false, isBeta: false, aggregationTimeout: timeout * 60)
    }
}
