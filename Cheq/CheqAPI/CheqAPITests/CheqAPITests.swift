//
//  CheqAPITests.swift
//  CheqAPITests
//
//  Created by XUWEI LIANG on 22/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
@testable import CheqAPI

class CheqAPITests: XCTestCase {

    func testHelloWorld() {
        let api = CheqAPI()
        XCTAssertTrue(api.helloWorld() == "Hello World")
    }
}
