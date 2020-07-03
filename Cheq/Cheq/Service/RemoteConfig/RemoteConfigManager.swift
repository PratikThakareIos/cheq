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


//https://console.firebase.google.com/project/dev-cheqapi/config


enum RemoteConfigParameters: String, CaseIterable {
    case financialInstitutions = "FinancialInstitutionsNew"
    case financialInstituitonsWithDemo = "FinancialInstitutionsWithDemoBank"
    case transactionSyncTimeoutMins = "TxnSyncTimeoutMins"
    case transactionBoardingTimeoutMins = "TxnOnBoardingTimeoutMins"
    
    case AppVersionNumberIos = "AppVersionNumberIos"
    case ForceAppVersionUpgradeIos = "ForceAppVersionUpgradeIos"
    case IsUnderMaintenance = "IsUnderMaintenance"
    
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    let remoteConfig = RemoteConfig.remoteConfig()
    private init() {
       
        // WARNING: Don't actually do this in production!
        let fetchDuration: TimeInterval = 0
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = fetchDuration
        remoteConfig.configSettings = settings
    }
    
    func fetchAndActivate()->Promise<Void> {
        return Promise<Void>() { resolver in
            self.remoteConfig.fetchAndActivate(completionHandler: { (status, err) in
                if let error = err {
                    print("Uh-oh. Got an error fetching remote values \(error)")
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
    
    func getRemoteConfigData()-> Promise<Void> {
       
        return Promise<Void>() { resolver in
            self.fetchAndActivate().done { _ in
        
                do {
                    
                    let appVersionNumberIos = self.remoteConfig.configValue(forKey: RemoteConfigParameters.AppVersionNumberIos.rawValue).stringValue ?? "0"
                    print("\n\nappVersionNumberIos: \(appVersionNumberIos)")
                    
                    let forceAppVersionUpgradeIos = self.remoteConfig.configValue(forKey: RemoteConfigParameters.ForceAppVersionUpgradeIos.rawValue).boolValue ?? false
                    print("\n\nForceAppVersionUpgradeIos:\(forceAppVersionUpgradeIos)")
                    

                    let isUnderMaintenance = self.remoteConfig.configValue(forKey: RemoteConfigParameters.IsUnderMaintenance.rawValue).boolValue ?? false
                    print("\n\nIsUnderMaintenance:\(isUnderMaintenance)")
                    
                    AppData.shared.remote_appVersionNumberIos = appVersionNumberIos
                    AppData.shared.remote_forceAppVersionUpgradeIos = forceAppVersionUpgradeIos
                    AppData.shared.remote_isUnderMaintenance  = isUnderMaintenance
                    
                    resolver.fulfill(())
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
