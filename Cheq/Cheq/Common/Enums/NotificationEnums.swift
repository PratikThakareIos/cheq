//
//  NotificationEventNames.swift
//  Cheq
//
//  Created by Xuwei Liang on 5/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

enum NotificationEvent: String {
    case apnsDeviceToken = "apns"
    case fcmToken = "fcm"
}

enum NotificationUserInfoKey: String {
    case token = "token"
}