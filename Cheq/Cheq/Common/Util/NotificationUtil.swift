//
//  NotificationUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class NotificationUtil {
    static let shared = NotificationUtil()
    private init() {
    }
    
    func notify(_ name: String, key: String, value: String) {
        // broadcast notification for token refresh app-wide
        let dataDict:[String: String] = [key: value]
        NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: dataDict)
    }
    
    func notify(_ name: String, key: String, value: Any!) {
        var dataDict:[String: Any] = [:]
        if value != nil {
            dataDict = [key: value]
        }
        NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: dataDict)
    }
}
