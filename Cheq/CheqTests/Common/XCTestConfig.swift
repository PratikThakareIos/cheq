//
//  XCTest_Extension.swift
//  CheqTests
//
//  Created by XUWEI LIANG on 27/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//
import Foundation

class XCTestConfig {

    static let shared = XCTestConfig()
    private init() {}

    let expectionTimeout = 30.0
}
