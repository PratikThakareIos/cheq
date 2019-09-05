//
//  Data_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
