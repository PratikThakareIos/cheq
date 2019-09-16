//
//  CheqAPIManagerImtegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Cheq 

class CheqAPIManagerImtegrationTests: XCTestCase {
    
    let authManager = AuthConfig.shared
    var authorizedUser: AuthUser?

    func testPutUserDetails() {
        let authUserUtil = AuthUserUtil.shared
        let userDetails = PutUserDetailRequest(firstName: authUserUtil.testFirstname(), lastName: authUserUtil.testLastname(), dateOfBirth: authUserUtil.testBirthday(), mobile: authUserUtil.testMobile(), residentialAddress: authUserUtil.testAddress())
        let expectation = XCTestExpectation(description: "testPutUserDetails")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = AuthUserUtil.shared.testEmail()
        credentials[.password] = AuthUserUtil.shared.testPass()
        authManager.activeManager.login(credentials)
        .then { authUser in
            CheqAPIManager.shared.putUserDetails(userDetails.firstName, lastName: userDetails.lastName, dateOfBirth: userDetails.dateOfBirth ?? Date(), mobile: userDetails.mobile, residentialAddress: userDetails.residentialAddress ?? "")
        }.done { updateUser in
           XCTAssertNotNil(updateUser)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testPutUserOnfidoKyc() {
        let authUserUtil = AuthUserUtil.shared
        let userDetails = PutUserDetailRequest(firstName: authUserUtil.testFirstname(), lastName: authUserUtil.testLastname(), dateOfBirth: authUserUtil.testBirthday(), mobile: authUserUtil.testMobile(), residentialAddress: authUserUtil.testAddress())
        let expectation = XCTestExpectation(description: "testPutUserDetails")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = AuthUserUtil.shared.testEmail()
        credentials[.password] = AuthUserUtil.shared.testPass()
        authManager.activeManager.login(credentials)
        .then { authUser in
            CheqAPIManager.shared.putUserDetails(userDetails.firstName, lastName: userDetails.lastName, dateOfBirth: userDetails.dateOfBirth ?? Date(), mobile: userDetails.mobile, residentialAddress: userDetails.residentialAddress ?? "")
        }.then { authUser -> Promise<PutUserKycResponse> in
            CheqAPIManager.shared.retrieveUserDetailsKyc()
        }.done { kycResponse in
            let resp: PutUserKycResponse = kycResponse
            XCTAssertNotNil(resp.sdkToken)
            XCTAssertNotNil(resp.applicantId)
            LoggingUtil.shared.cPrint(resp.sdkToken ?? "")
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testCheckKYCPhotoUploaded() {
        let expectation = XCTestExpectation(description: "testPutUserDetails")
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = AuthUserUtil.shared.testEmail()
        credentials[.password] = AuthUserUtil.shared.testPass()
        AuthConfig.shared.activeManager.login(credentials)
        .then { authUser->Promise<Bool> in
            CheqAPIManager.shared.checkKYCPhotoUploaded()
        }.done { uploaded in
            XCTFail()
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTAssertTrue(true)
        }.finally {
             expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
