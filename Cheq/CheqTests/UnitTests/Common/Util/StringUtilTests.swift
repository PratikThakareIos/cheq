//
//  StringUtilTests.swift
//  CheqTests
//
//  Created by XUWEI LIANG on 19/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import XCTest
@testable import Cheq

class StringUtilTests: XCTestCase {

    func testDecode64() {
        let result = StringUtil.shared.decodeBase64("MzkxNTc3RTRBMDI4NDE1Rjk5NjVjY2IwNjkzZTU2ZjU=")
        LoggingUtil.shared.cPrint(result)
        XCTAssertTrue(result == "391577E4A028415F9965ccb0693e56f5")
    }
    
    // Password must be more than 6 characters, with at least one capital, numeric or special character (@,!,#,$,%,&,?)
    func testIsValidPassword() {
        let pass1 = "A1?=.*[@!#$%&? "
        let result1 = StringUtil.shared.isValidPassword(pass1)
        XCTAssertTrue(result1)
        
        let pass2 = "Password123!"
        let result2 = StringUtil.shared.isValidPassword(pass2)
        XCTAssertTrue(result2)
        
        let pass3 = "Password%123"
        let result3 = StringUtil.shared.isValidPassword(pass3)
        XCTAssertTrue(result3)
        
        let pass4 = "Password?123"
        let result4 = StringUtil.shared.isValidPassword(pass4)
        XCTAssertTrue(result4)
        
        let pass5 = "Good321321321Password@"
        let result5 = StringUtil.shared.isValidPassword(pass5)
        XCTAssertTrue(result5)
        
        let pass6 = "Aabcwdef"
        let result6 = StringUtil.shared.isValidPassword(pass6)
        XCTAssertFalse(result6)
    }
    
    func testIsValidPasswordNegative() {
        
        let pass1 = "asda"
        let result1 = StringUtil.shared.isValidPassword(pass1)
        XCTAssertFalse(result1)
        
        let pass2 = "asdasdsad"
        let result2 = StringUtil.shared.isValidPassword(pass2)
        XCTAssertFalse(result2)
        
        
        let pass3 = "3213213213"
        let result3 = StringUtil.shared.isValidPassword(pass3)
        XCTAssertFalse(result3)
        
        let pass4 = "DSADSADSADSA"
        let result4 = StringUtil.shared.isValidPassword(pass4)
        XCTAssertFalse(result4)
    }
}
