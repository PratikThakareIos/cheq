//
//  MoneySoftManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 2/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class MoneySoftManager {
    static let shared = MoneySoftManager()
    let API_BASE_URL = "https://api.beta.moneysoft.com.au"
    let API_REFERRER = "https://cheq.beta.moneysoft.com.au"
    
    private init() {
        let config = MoneysoftApiConfiguration.init(apiUrl: API_BASE_URL, apiReferrer: API_REFERRER, view: UIView())
        MoneysoftApi.configure(config)
    }
    
    class func getProfile()-> Promise<Void> {
        return Promise<Void>() { resolver in
            
        }
    }

}
