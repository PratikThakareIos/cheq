//
//  StringUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 19/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Foundation

class StringUtil {
    static let shared = StringUtil()
    private init() {}

    func decodeBase64(_ base64Encoded: String)-> String {
        guard let decodedData = Data(base64Encoded: base64Encoded) else { return "" }
        return String(data: decodedData, encoding: .utf8) ?? ""
    }

    func isNumericOnly(_ string: String)-> Bool {
        return !string.isEmpty && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isAlphaOnly(_ string: String)-> Bool {
        var alphaOnlySet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        return !string.isEmpty && string.rangeOfCharacter(from: alphaOnlySet.inverted) == nil
    }
}
