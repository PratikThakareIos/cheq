//
//  StringUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 19/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Foundation

/**
 String Utility class to encapsulate reusable helper methods for String class.
 */
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
    
    func isAlphaNumericOnly(_ string: String)-> Bool {
        let alphaOnlySet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.- 0123456789")
        return !string.isEmpty && string.rangeOfCharacter(from: alphaOnlySet.inverted) == nil
    }
    
    func isAlphaOnly(_ string: String)-> Bool {
        let alphaOnlySet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.- ")
        return !string.isEmpty && string.rangeOfCharacter(from: alphaOnlySet.inverted) == nil
    }
    
    func isValidEmail(_ string: String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
    }
    
    // Password must be more than 6 characters, with at least one capital, numeric or special character (@,!,#,$,%,&,?)
    func isValidPassword(_ string: String)-> Bool {
        let passwordRegex = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[@!#$%&?\"]).*$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: string)
    }
}
