//
//  NotificationEventNames.swift
//  Cheq
//
//  Created by Xuwei Liang on 5/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

/**
 NotificationEvent for events across the app, don't hardcode event names, update enum for lookup instead
 */
enum NotificationEvent: String {
    case apnsDeviceToken = "apns"
    case fcmToken = "fcm"
    case dismissKeyboard = "dismissKeyboard"
    case logout = "logout"
    case login = "login"
    case deleteBackward = "delete"
    case appBecomeActive = "appBecomeActive"
    case appBecomeIdle = "appBecomeIdle"
}


/**
 UINotificationEvent is UI related notification event, update when we want support for types of UI notifications
 */
enum UINotificationEvent: String {
    case completeDetails = "completeDetails"
    case buttonClicked = "buttonClicked"
    case reloadTableLayout = "reloadTableLayout"
    case reloadTable = "reloadTable"
    case swipeConfirmation = "swipeConfirmation"
    case swipeReset = "swipeReset"
    case lendingOverview = "lendingOverview"
    case spendingOverviuew = "spendingOverview"
    case spendingCategories = "spendingCategories"
    case spendingTransactions = "spendingTransactions"
    case selectedCategoryById = "selectedCategoryById"
    case accountInfo = "accountInfo"
    case loadCategoryById = "loadCategoryById"
    case previewLoan = "previewLoan" 
    case intercom = "intercom"
    case switchRoot = "switchRoot"
    case showError = "showError"
    case showTransaction = "showTransaction"
    case openLink = "openLink" 
    case viewAll = "viewAll"
    case mixPanelEvent = "mixPanelEvent"
}

/**
 NotificationUserInfoKey are keys for accessing objects from UserInfo inside notifications, don't want to hardcode any String in our code for accessing UserInfo from notification, update this enum and use enum's rawValue to access instead. 
 */
enum NotificationUserInfoKey: String {
    case token = "token"
    case cell = "cell"
    case button = "button"
    case vcInfo = "vcInfo"
    case storyboardName = "storyboardName"
    case storyboardId = "storyboardId"
    case err = "err"
    case category = "category"
    case viewAll = "viewAll"
    case transaction = "transaction"
    case link = "link"
    case mixpanel = "mixpanel"
}
