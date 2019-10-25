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
    case financialInstitutions = "FinancialInstitutions"
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    let remoteConfig = RemoteConfig.remoteConfig()
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
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
    
    func remoteBanks()->Promise<RemoteBankList> {
       
        return Promise<RemoteBankList>() { resolver in
            self.fetchAndActivate().done { _ in
                let banks = self.remoteConfig.configValue(forKey: RemoteConfigParameters.financialInstitutions.rawValue)
                let decoder = JSONDecoder()
                do {
                    let remoteBanks = try decoder.decode([RemoteBank].self, from: banks.dataValue)
                    LoggingUtil.shared.cPrint(remoteBanks)
                    let remoteBankList = RemoteBankList(banks: remoteBanks)
                    AppData.shared.remoteBankMapping = remoteBankList.mapping()
                    resolver.fulfill(remoteBankList)
                }
                catch let error {
                    resolver.reject(error)
                }
            }.catch { err in
                resolver.reject(RemoteConfigError.unableToFetchInstitutions)
            }
        }
    }
    
}
