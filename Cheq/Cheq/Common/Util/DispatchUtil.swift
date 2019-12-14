//
//  DispatchUtil.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

/**
 Helper methods using **DispatchQueue**
 */
struct DispatchUtil {

    /**
    Method to create a delay on executing the given closure
    - parameter delay: the amount of delay in seconds
    - parameter closure: the closure to be executed on **DispatchQueue.main** after the delay
    */
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
