//
//  PostRepaymentPayRequest.swift
//  CheqDev
//
//  Created by Sachin Amrale on 06/10/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation

public struct PostRepaymentPayRequest: Codable {

    public var amount: Double

    public init(amount: Double) {
        self.amount = amount
    }
}
