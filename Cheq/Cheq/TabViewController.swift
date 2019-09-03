//
//  TabViewController.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import Firebase

class TabViewController: UITabBarController {

    let theme = sharedAppConfig.activeTheme

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = sharedAppConfig.activeTheme.backgroundColor
        self.runTests()
    }
    
    func runTests() {
        runTest1()
    }

    func runTest1() {
        let moneySoftManager = MoneySoftManager.shared
        let firebaseAuth = FirebaseAuthManager.shared
        let authUserUtil = AuthUserUtil()
        let email = authUserUtil.randomEmail()
        let password = authUserUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
            .then { authUser in
                firebaseAuth.login(credentials)
            }.then { authUser->Promise<MoneySoftUser> in
                moneySoftManager.getUserDetails(authUser)
            }.done { msUser in
                
            }.catch { err in
                
            }
    }
}
