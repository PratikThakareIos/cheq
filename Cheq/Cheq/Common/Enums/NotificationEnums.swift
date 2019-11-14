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
    case login = "login"
    case deleteBackward = "delete"
    case appBecomeActive = "appBecomeActive"
    case appBecomeIdle = "appBecomeIdle"
}

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
    case loadCategoryById = "loadCategoryById"
    case previewLoan = "previewLoan" 
    case intercom = "intercom"
    case switchRoot = "switchRoot"
    case showError = "showError"
    case showTransaction = "showTransaction"
    case viewAll = "viewAll"
}

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
}
