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
    case dismissKeyboard = "dismissKeyboard"
    case logout = "logout"
    case deleteBackward = "delete"
    case appBecomeActive = "appBecomeActive"
    case appBecomeIdle = "appBecomeIdle"
}

enum UINotificationEvent: String {
    case completeDetails = "completeDetails"
    case buttonClicked = "buttonClicked"
    case reloadTableLayout = "reloadTableLayout"
    case swipeConfirmation = "swipeConfirmation"
    case lendingOverview = "lendingOverview"
    case intercom = "intercom"
}

enum NotificationUserInfoKey: String {
    case token = "token"
    case cell = "cell"
}
