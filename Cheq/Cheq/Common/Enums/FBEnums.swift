//
//  FBEnums.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

let fbPermissions:[String] = [FBKey.email.rawValue, FBKey.userBirthday.rawValue, FBKey.publicProfile.rawValue]

let fbIconImage = "fbIcon"

enum FBKey: String {
    case firstname = "first_name"
    case lastname = "last_name"
    case email = "email"
    case userBirthday = "user_birthday"
    case birthday = "birthday"
    case publicProfile = "public_profile"
}
