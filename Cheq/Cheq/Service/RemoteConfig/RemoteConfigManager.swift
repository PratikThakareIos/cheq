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
    
    func bankLogos()->Promise<[String: String]> {
       
        return Promise<[String: String]>() { resolver in
            
            var logoMapping = [String: String]()
            self.fetchAndActivate().done { _ in
                let banks = self.remoteConfig.configValue(forKey: RemoteConfigParameters.financialInstitutions.rawValue)
                do {
//                    let arr = try JSONSerialization.jsonObject(with: banks.dataValue, options: .allowFragments) as! [String:String]
//
//                    LoggingUtil.shared.cPrint(arr)
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
