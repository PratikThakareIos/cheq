//
//  VDotManagerTests.swift
//  CheqTests
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
//import CoreLocation
@testable import Cheq

class VDotManagerTests: XCTestCase {
    let vDotManager = VDotManager.shared
    
    func testDateFormatting() {
        let now = Date()
        let dateString = vDotManager.dateFormatter.string(from: now)
        XCTAssertNotNil(dateString)
        XCTAssertTrue(true)
    }
    
    func testIsAtWorkPositive() {
        XCTAssertTrue(result)
    }
    
    func testIsAtWorkNegative() {
        XCTAssertFalse(result)
    }
}
