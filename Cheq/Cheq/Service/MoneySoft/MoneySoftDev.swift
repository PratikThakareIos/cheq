//
//  MoneySoftEndpoints.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

struct MoneySoft {
    static let API_BASE_URL = "https://api.beta.moneysoft.com.au"
    static let API_REFERRER = "https://cheq.beta.moneysoft.com.au"
    static func config()-> MoneysoftApiConfiguration {
        // timeout is in seconds 
        let timeout = RemoteConfigManager.shared.remoteNumberValue(RemoteConfigParameters.transactionBoardingTimeoutMins.rawValue)?.intValue ?? 10
        
        return MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: true, isBeta: true, serviceProvider: .EWISE, aggregationTimeout: timeout * 600)
    }
    
    static func bgTaskConfig()-> MoneysoftApiConfiguration {
        let timeout = RemoteConfigManager.shared.remoteNumberValue(RemoteConfigParameters.transactionSyncTimeoutMins.rawValue)?.intValue ?? 10
        return MoneysoftApiConfiguration.init(apiUrl: MoneySoft.API_BASE_URL, apiReferrer: MoneySoft.API_REFERRER, view: UIView(), isDebug: false, isBeta: true, serviceProvider: .EWISE, aggregationTimeout: timeout * 600)
    }
}
