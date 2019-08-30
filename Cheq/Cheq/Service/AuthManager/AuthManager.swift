//
//  AuthManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

let sharedAuthManager = AuthConfig()

class AuthConfig: NSObject {
    var activeManager = FirebaseAuthManager()
}
