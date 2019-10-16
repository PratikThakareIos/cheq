//
//  IntercomManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Intercom
import PromiseKit

class IntercomManager {
    static let shared = IntercomManager()
    private init() {
        Intercom.setApiKey(AppData.shared.intercomAPIKey, forAppId: AppData.shared.intercomAppId)
    }
    
    func present() {
        Intercom.presentMessenger()
    }
    
    func logoutIntercom()->Promise<Void> {
        return Promise<Void>() { resolver in
            Intercom.logout()
            resolver.fulfill(())
        }
    }
    
    func loginIntercom()->Promise<AuthUser> {
        
        return Promise<AuthUser>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().done { authUser in
                let userId = authUser.userId
                Intercom.registerUser(withUserId: userId)
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
