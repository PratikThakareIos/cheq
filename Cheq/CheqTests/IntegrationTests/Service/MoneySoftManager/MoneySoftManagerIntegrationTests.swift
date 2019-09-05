//
//  MoneySoftManagerIntegrationTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
import PromiseKit
import Firebase
import MobileSDK
@testable import Cheq 

class MoneySoftManagerIntegrationTests: XCTestCase {

    let moneySoftManager = MoneySoftManager.shared
    let authUserUtil = AuthUserUtil.shared
    let firebaseAuth = FirebaseAuthManager.shared
    
    func testMoneySoftCredentials() {
        let expectation = XCTestExpectation(description: "test money soft sdk integrations")
        let login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount()
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            banks.forEach {
                let name = $0.name ?? ""
                LoggingUtil.shared.cPrint(name)
            }
            let selected = banks.first(where: { $0.name == "St.George Bank"})
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.done { credentialsFormModel in
            let form: InstitutionCredentialsFormModel = credentialsFormModel
            LoggingUtil.shared.cPrint(form)
            XCTAssertTrue(true)
        }.catch { err in
            XCTFail()
            LoggingUtil.shared.cPrint(err)
        }.finally {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: XCTestConfig.shared.expectionTimeout)
    }
}
