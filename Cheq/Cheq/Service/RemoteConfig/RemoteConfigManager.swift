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
        let fetchDuration: TimeInterval = 60 * 5 // 5 mins.
        
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
                    
                    let forceAppVersionUpgradeIos = self.remoteConfig.configValue(forKey: RemoteConfigParameters.ForceAppVersionUpgradeIos.rawValue).boolValue

                    let isUnderMaintenance = self.remoteConfig.configValue(forKey: RemoteConfigParameters.IsUnderMaintenance.rawValue).boolValue
                    
//                  LoggingUtil.shared.cPrint("appVersionNumberIos: \(appVersionNumberIos)")
//                  LoggingUtil.shared.cPrint("ForceAppVersionUpgradeIos:\(forceAppVersionUpgradeIos)")
//                  LoggingUtil.shared.cPrint("IsUnderMaintenance:\(isUnderMaintenance)")
                    
                    AppData.shared.remote_appVersionNumberIos = appVersionNumberIos
                    AppData.shared.remote_forceAppVersionUpgradeIos = forceAppVersionUpgradeIos
                    AppData.shared.remote_isUnderMaintenance  = isUnderMaintenance
                    
                    resolver.fulfill(())
                    
                }catch let error {
                    LoggingUtil.shared.cPrint("Error occured in \(error)")
                    resolver.reject(error)
                }
                
            }.catch { err in
                resolver.reject(RemoteConfigError.unableToFetchAndActivateRemoteConfig)
            }
        }
    }
 
    func getApplicationStatusFromRemoteConfig()-> Promise<Bool> {
    
         return Promise<Bool>() { resolver in
              
            RemoteConfigManager.shared.getRemoteConfigData().done { _ in
                     
              LoggingUtil.shared.cPrint(" AppData.shared.remote_appVersionNumberIos = \( AppData.shared.remote_appVersionNumberIos)")
              LoggingUtil.shared.cPrint(" AppData.shared.remote_forceAppVersionUpgradeIos = \( AppData.shared.remote_forceAppVersionUpgradeIos)")
              LoggingUtil.shared.cPrint(" AppData.shared.remote_isUnderMaintenance = \( AppData.shared.remote_isUnderMaintenance)")
                
                if (AppData.shared.remote_isUnderMaintenance){
                    LoggingUtil.shared.cPrint("goto_MaintenanceVC")
                    NotificationUtil.shared.notify(UINotificationEvent.showMaintenanceVC.rawValue, key: "", value: "")
                    resolver.fulfill(true)
                }else if (AppData.shared.remote_forceAppVersionUpgradeIos){
                                
                     if let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                         LoggingUtil.shared.cPrint("currentAppVersion \(currentAppVersion)")
                         LoggingUtil.shared.cPrint(currentAppVersion)
                        
                        if AppData.shared.remote_appVersionNumberIos != "" {
                           let isNeedUpdate = AppData.shared.remote_appVersionNumberIos.isVersion(greaterThan: currentAppVersion)
                            LoggingUtil.shared.cPrint("isNeedUpdate \(isNeedUpdate)")
                            if (isNeedUpdate){
                                NotificationUtil.shared.notify(UINotificationEvent.showUpdateAppVC.rawValue, key: "", value: "")
                                resolver.fulfill(true)
                            }
                        }
                     }
                }
                
                resolver.fulfill(false)
                
            }.catch { [weak self] err in
                LoggingUtil.shared.cPrint("Err in getApplicationStatusFromRemoteConfig")
                LoggingUtil.shared.cPrint(err)
                resolver.reject(RemoteConfigError.unableToFetchAndActivateRemoteConfig)
            }
         }
    }
}


