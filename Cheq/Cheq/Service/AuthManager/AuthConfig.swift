//
//  AuthManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AuthConfig {

    static let shared = AuthConfig()
    private init() {}

    var activeManager = FirebaseAuthManager.shared
    var activeUser: AuthUser?
}
