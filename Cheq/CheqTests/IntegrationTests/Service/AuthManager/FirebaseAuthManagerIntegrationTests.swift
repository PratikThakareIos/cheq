//
//  FirebaseAuthManagerTests.swift
//  CheqTests
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import Firebase
import PromiseKit
@testable import Cheq

class FirebaseAuthManagerIntegrationTests: XCTestCase {

    let dataUtil = DataHelperUtil.shared
    let firebaseAuth = FirebaseAuthManager.shared

    func testRestPasswordLink() {
        let expectation = XCTestExpectation(description: "registration with email, login, then request for password reset link")
        let email = "xuwei_liang@hotmail.com"
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser->Promise<Void> in
            self.firebaseAuth.sendResetPassword(credentials)
        }.done {
            XCTAssertTrue(true)
        }.catch { err in
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register, Login, Update Password, Logout, Delete Account
    func testUpdatePassword() {
        let expectation = XCTestExpectation(description: "email registration, login then update user password")
        let email = dataUtil.randomEmail()
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        let newCredential: [LoginCredentialType: String] =
            [.email: email, .password: dataUtil.randomPassword()]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser->Promise<Void> in
            self.firebaseAuth.updatePassword(newCredential)
        }.then { ()-> Promise<AuthUser> in
            self.firebaseAuth.getCurrentUser()
        }.then { authUser in
            self.firebaseAuth.logout(authUser)
        }.then { ()->Promise<AuthUser> in
            self.firebaseAuth.login(newCredential)
        }.done{ authUser in
            XCTAssertNotNil(authUser)
            XCTAssertTrue(true)
            XCTAssertNotNil(authUser.authToken)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    func testRemoveUserAccount2() {
        let expectation = XCTestExpectation(description: "email registration, login then remove user account")
        let email = dataUtil.randomEmail()
        LoggingUtil.shared.cPrint(email)
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser->Promise<Void> in
            self.firebaseAuth.logout(authUser)
        }.then { ()->Promise<AuthUser> in 
            self.firebaseAuth.getCurrentUser()
        }.then { authUser in
            self.firebaseAuth.removeUserAcct(authUser)
        }.done{
            XCTAssertTrue(true)
        }.catch{ err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register, Login, Remove User Account
    func testRemoveUserAccount() {
        let expectation = XCTestExpectation(description: "email registration, login then remove user account")
        let email = dataUtil.randomEmail()
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser in
            self.firebaseAuth.removeUserAcct(authUser)
        }.done{
            XCTAssertTrue(true)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register, Login, Logout
    func testRegisterLoginThenLogout2() {
        let expectation = XCTestExpectation(description: "email registration, login then logout with email")
        let email = dataUtil.randomEmail()
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .then { authUser in
            self.firebaseAuth.login(credentials)
        }.then { authUser->Promise<Void> in
            self.firebaseAuth.logout(authUser)
        }.done{
            XCTAssertTrue(true)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register, Login, Logout
    func testRegisterLoginThenLogout() {
        let expectation = XCTestExpectation(description: "email registration, login then logout with email")
        let email = dataUtil.randomEmail()
        let password = dataUtil.randomPassword()
        let credentials:[LoginCredentialType: String] = [.email: email, .password: password]
        firebaseAuth.register(.socialLoginEmail, credentials: credentials)
        .done { authUser in
            self.firebaseAuth.login(credentials)
            .then { loggedInUser in
                self.firebaseAuth.logout(loggedInUser)
            }.done {
                XCTAssertTrue(true)
            }.catch {err in
                XCTAssertNotNil(err)
                LoggingUtil.shared.cPrint(err)
                XCTFail()
            }.finally {
                expectation.fulfill()
            }
        }.catch{ err in
            XCTFail()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register with existing email
    func testRegisterWithExistingEmail() {
        let expectation = XCTestExpectation(description: "registration with email")
        firebaseAuth.register(.socialLoginEmail, credentials: [.email: dataUtil.testEmail() , .password: dataUtil.randomPassword()])
        .done { authUser in
            XCTAssertThrowsError("testRegisterWithExistingEmail shoudn't work")
        }.catch { err in
            XCTAssertNotNil(err)
            LoggingUtil.shared.cPrint(err.localizedDescription)
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }

    // Register with randomly generated email
    func testRegisterWithNewEmail() {
        let expectation = XCTestExpectation(description: "registration with email")
        firebaseAuth.register(.socialLoginEmail, credentials: [.email: dataUtil.randomEmail(), .password: dataUtil.randomPassword()])
            .done { authUser in
                XCTAssertNotNil(authUser)
                XCTAssertNotNil(authUser.email)
                XCTAssertNotNil(authUser.userId)
                // lets check if we got auth token too
                let authToken = authUser.authToken() ?? ""
                XCTAssertNotNil(authToken)
                XCTAssertTrue(authToken.count > 0)
                LoggingUtil.shared.cPrint("authToken \(authToken)")
        }.catch { err in
            LoggingUtil.shared.cPrint(err.localizedDescription)
            XCTAssertThrowsError("testRegisterWithNewEmail should work")
        }.finally {
            expectation.fulfill()
        }

        // timeout of 20 seconds.
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testRegisterTestAccount() {
        let expectation = XCTestExpectation(description: "registration for test account")
        firebaseAuth.register(.socialLoginEmail, credentials: [.email: dataUtil.testEmail(), .password: DataHelperUtil.shared.testPass()]).done { authUser in
            XCTAssertNotNil(authUser)
            XCTAssertNotNil(authUser.email)
            XCTAssertNotNil(authUser.userId)
        }.catch {err in
            LoggingUtil.shared.cPrint(err)
            XCTFail()
        }.finally {
            expectation.fulfill()
        }
        // timeout of 20 seconds.
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
    
    func testDeleteTestAccount() {
        let expectation = XCTestExpectation(description: "delete test account")
        firebaseAuth.login([.email: DataHelperUtil.shared.testEmail(), .password: DataHelperUtil.shared.testPass()]).then { authUser in
            self.firebaseAuth.removeUserAcct(authUser)
        }.done {
            XCTAssertTrue(true)
        }.catch { err in
            XCTFail()
        }.finally {
            expectation.fulfill()
        }

        // timeout of 20 seconds.
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
