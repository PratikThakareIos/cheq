//
//  MoneySoftManagerIntegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest

class MoneySoftManagerIntegrationTests: XCTestCase {

    let moneySoftManager = MoneySoftManager.shared

    func testGetMoneySoftCredentials() {
        let expectation = XCTestExpectation(description: "registration with email, login, then get money soft credentials")
        let email = authUserUtil.randomEmail()
        let password = authUserUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser->Promise<MoneySoftUser> in
            moneySoftManager.getUserDetails(authUser)
        }.then { msUser in
            LoggingUtil.shared.cPrint("hello")
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
