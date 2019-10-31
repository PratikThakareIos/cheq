//
//  RemoteConfigManagerIntegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 25/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Cheq

class RemoteConfigManagerIntegrationTests: XCTestCase {

    let authManager = AuthConfig.shared

    func testRemoteConfigBanks() {
        let expectation = XCTestExpectation(description: "testRemoteConfigBanks")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).then { authUser->Promise<RemoteBankList> in
            LoggingUtil.shared.cPrint("register")
            return RemoteConfigManager.shared.remoteBanks()
        }.done { remoteBankList in
            XCTAssertNotNil(remoteBankList)
            XCTAssertTrue(remoteBankList.banks.count > 0)
            expectation.fulfill()
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
