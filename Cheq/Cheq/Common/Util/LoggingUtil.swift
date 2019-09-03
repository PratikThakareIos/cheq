//
//  LoggingUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

class LoggingUtil {
    static let shared = LoggingUtil()
    private init() {
    }
    
    // we will turn off this for prod use
    func cPrint(_ msg: Any...) {
        print(msg)
    }
}
