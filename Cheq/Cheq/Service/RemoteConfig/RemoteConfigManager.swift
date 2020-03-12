//
//  RemoteConfigManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 22/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import PromiseKit


enum RemoteConfigParameters: String, CaseIterable {
    case financialInstitutions = "FinancialInstitutionsNew"
    case financialInstituitonsWithDemo = "FinancialInstitutionsWithDemoBank"
    case appVersionNumber = "AppVersionNumber"
    case transactionSyncTimeoutMins = "TxnSyncTimeoutMins"
    case transactionBoardingTimeoutMins = "TxnOnBoardingTimeoutMins"
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    let remoteConfig = RemoteConfig.remoteConfig()
    private init() {
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
    }
    
    func fetchAndActivate()->Promise<Void> {
        return Promise<Void>() { resolver in
            self.remoteConfig.fetchAndActivate(completionHandler: { (status, err) in
                if let error = err {
                    LoggingUtil.shared.cPrint(error)
                    resolver.reject(RemoteConfigError.unableToFetchAndActivateRemoteConfig)
                    return
                }
                resolver.fulfill(())
            })
        }
    }
    
    func remoteNumberValue(_ key: String)-> NSNumber? {
        let remoteConfigValue = remoteConfig.configValue(forKey: key)
        return remoteConfigValue.numberValue
    }
    
    func remoteBanks()->Promise<RemoteBankList> {
       
        return Promise<RemoteBankList>() { resolver in
            self.fetchAndActivate().done { _ in
                let banks = self.remoteConfig.configValue(forKey: RemoteConfigParameters.financialInstitutions.rawValue)
                print("Banks:",banks)
                let decoder = JSONDecoder()
                do {
                    let remoteBanks = try decoder.decode([RemoteBank].self, from: banks.dataValue)
                    LoggingUtil.shared.cPrint(remoteBanks)
                    let remoteBankList = RemoteBankList(banks: remoteBanks)
                    AppData.shared.remoteBankMapping = remoteBankList.mapping()
                    resolver.fulfill(remoteBankList)
                }
                catch let error {
                    print("Error occured in",error)
                    resolver.reject(error)
                }
            }.catch { err in
                resolver.reject(RemoteConfigError.unableToFetchAndActivateRemoteConfig)
            }
        }
    }
    
}
