//
//  NotificationUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import UserNotifications

/**
Notification Utility class encapsulating the logics to trigger a notification using **NotificationCenter**  methods. Always use **NotificationUtil** to avoid repeated logic existing else where for raising notification.
*/
class NotificationUtil {
    
    /// Singleton instance of **NotificationUtil**
    static let shared = NotificationUtil()
    
    /// private init to ensure
    private init() {
    }
    
    /**
     Method to trigger a notification and carry key-value pair along with the notification's userInfo dictionary.
     - parameter key: userInfo key for storing the value content
     - parameter value: actual value content to be carry by notification
     */
    func notify(_ name: String, key: String, value: String) {
        // broadcast notification for token refresh app-wide
        let dataDict:[String: String] = [key: value]
        NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: dataDict)
    }
    
    /**
     Method to trigger notification and carry key-object pair along with the notification's userInfo dictionary.
     - parameter key: userInfo key for storing the object content
     - parameter value: actual object instance to be carry by notification
     */
    func notify(_ name: String, key: String, object: Any!) {
        var dataDict:[String: Any] = [:]
        if object != nil {
            dataDict = [key: object]
        }
        NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: dataDict)
    }
}
