//
//  FBEnums.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

/// array of FB permissions which we request when we log in using Facebook
let fbPermissions:[String] = [FBKey.email.rawValue, FBKey.publicProfile.rawValue]


/// image asset name for Facebook icon
let fbIconImage = "fbIcon"


/// keys to extract Facebook profile information
enum FBKey: String {
    case firstname = "first_name"
    case lastname = "last_name"
    case email = "email"
    case userBirthday = "user_birthday"
    case birthday = "birthday"
    case publicProfile = "public_profile"
}
