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
}
