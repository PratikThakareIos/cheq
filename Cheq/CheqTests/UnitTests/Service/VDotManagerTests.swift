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
        let current = CLLocation(latitude: -33.8653556
            , longitude: 151.205377)
        //vDotManager.markedLocation = current
        //let result = vDotManager.isAtWork(current)
        XCTAssertTrue(result)
    }
    
    func testIsAtWorkNegative() {
        let work = CLLocation(latitude: -33.8653556
            , longitude: 151.205377)
        let current2 = CLLocation(latitude: -33.8753556
            , longitude: 151.215377)
        //vDotManager.markedLocation = work
        //let result = vDotManager.isAtWork(current2)
        XCTAssertFalse(result)
    }
}
