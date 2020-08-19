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
    
    /// Singleton instance of **StringUtil**
    static let shared = StringUtil()
    
    /// private init method for Singleton implementation
    private init() {}

    /** Helper method to decode a base64 String
    - parameter base64Encoded: base64 encoded String
    - returns: the decoded String
    */
    func decodeBase64(_ base64Encoded: String)-> String {
        guard let decodedData = Data(base64Encoded: base64Encoded) else { return "" }
        return String(data: decodedData, encoding: .utf8) ?? ""
    }

    /// Validate if a given String is numeric only. Returns true if it's true.
    func isNumericOnly(_ string: String)-> Bool {
        return !string.isEmpty && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// Validate if a given String is alphabet, full stop, dash, space and numbers only.
    func isAlphaNumericOnly(_ string: String)-> Bool {
        let alphaOnlySet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.- 0123456789")
        return !string.isEmpty && string.rangeOfCharacter(from: alphaOnlySet.inverted) == nil
    }
    
//    /// Validate if a given String is alphabet, full stop, dash and space
//    func isAlphaOnly(_ string: String)-> Bool {
//        let alphaOnlySet = CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.- ")
//        return !string.isEmpty && string.rangeOfCharacter(from: alphaOnlySet.inverted) == nil
//    }
    
    func isAlphaOnly(_ string: String)-> Bool{
           ///valid name accept english characters , space, (-) and (') symbols
           let nameRegEx = "[a-zA-Z'-][a-zA-Z' -]*"   //"[a-zA-Z][a-zA-Z ]*"
           let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
           let result = nameTest.evaluate(with: string)
           return result
    }
    

    
//    /// Validate if a given String is a valid email format
//    func isValidEmail(_ string: String) -> Bool {
//        // here, `try!` will always succeed because the pattern is valid
//        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
//        return regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
//    }
    
    
    /// Validate if a given String is a valid email format
    func isValidEmail(_ string: String) -> Bool  {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: string)
    }
    
    
    /// Password must be more than 6 characters, with at least one capital, numeric or special character (@,!,#,$,%,&,?)
    /*
    func isValidPassword(_ string: String)-> Bool {
       // let passwordRegex = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[@!#$%&?\"]).*$"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: string)
    }
    */
    
    
    ///NNN
//    func isValidPassword(_ string: String)-> Bool {
//         // let passwordRegex = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[@!#$%&?\"]).*$"
//           let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,40}"
//           return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: string)
//
//    }
    
    
   func isValidPassword(_ string: String)-> Bool {
      //“At least 6 characters long with 1 upper case character and 1 number”
      
      let isValidLenght = isValidPasswordLenght(string)
      let isUpperCase = isContainUpperCase(string)
      let isContainNumber = isContainAnyNumber(string)
       
//       print("isValidLenght = \(isValidLenght)")
//       print("isUpperCase = \(isUpperCase)")
//       print("isContainNumber = \(isContainNumber)")
       
       if (isValidLenght && isUpperCase && isContainNumber){
           return true
       }
       return false
   }

   func isContainAnyNumber(_ string: String)-> Bool{

       let decimalCharacters = CharacterSet.decimalDigits
       let decimalRange = string.rangeOfCharacter(from: decimalCharacters)

       if decimalRange != nil {
           //"Numbers found"
           return true
       }
       return false
   }

   func isContainUpperCase(_ string: String)-> Bool{
       
       let uppercaseRegex = ".*[A-Z].*"
       let nameTest = NSPredicate (format:"SELF MATCHES %@",uppercaseRegex)
       let result = nameTest.evaluate(with: string)
       return result
   }

   func isValidPasswordLenght(_ string: String)-> Bool{
       
       let min_VALID_PASSWORD_LENGTH =  6
       let max_VALID_PASSWORD_LENGTH =  40
       
       if (string.count >= min_VALID_PASSWORD_LENGTH && string.count <= max_VALID_PASSWORD_LENGTH) {
           return true
       }
       return false
   }

}

