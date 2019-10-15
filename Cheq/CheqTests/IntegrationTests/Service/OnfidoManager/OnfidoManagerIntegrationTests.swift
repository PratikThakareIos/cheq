//
//  OnfidoManagerIntegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Cheq

class OnfidoManagerIntegrationTests: XCTestCase {
    
    func testOnfidoManagerSetup() {
        let expectation = XCTestExpectation(description: "test onfido sdk integrations")
        var credentials: [LoginCredentialType: String] = [:]
        credentials[.email] = TestUtil.shared.testEmail()
        credentials[.password] = TestUtil.shared.testPass()
        firstly {
            return AuthConfig.shared.activeManager.login(credentials)
//        }.then { authUser
//
        }.done { authUser in
        }.catch { err in
            XCTFail()
        }.finally {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

}

//let token = authUser.authToken() ?? ""
//UsersAPI.putUserOnfidoKycWithRequestBuilder().addHeader(name: HttpHeaderKeyword.authorization.rawValue, value: String("\(HttpHeaderKeyword.bearer.rawValue) \(token)")).execute( { [weak self] (result, error) in
//    guard let self = self else { return }
//    if let err: Error = error {
//        LoggingUtil.shared.cPrint(err.localizedDescription)
//    }
//    expectation.fulfill()
