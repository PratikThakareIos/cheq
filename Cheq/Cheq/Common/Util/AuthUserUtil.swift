//
//  EmailUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 23/8/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

struct AuthUserUtil {

    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
    let suffix = ["gmail.com", "hotmail.com", "facebook.com", "cheq.com.au"]

    fileprivate func randomString(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(letters.randomElement() ?? "a")
        }
        return result
    }

    func randomEmail()-> String {
        let randomPrefix = randomString(20)
        let randomSuffix = suffix.randomElement() ?? "gmail.com"
        return "\(randomPrefix)@\(randomSuffix)"
    }

    func randomPassword()-> String {
        return randomString(12)
    }

    func weakPassword()-> String {
        return "12345678"
    }
}