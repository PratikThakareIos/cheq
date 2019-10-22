//
//  RemoteBank.swift
//  Cheq
//
//  Created by Xuwei Liang on 22/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

struct RemoteBankList: Codable {
    var banks: [RemoteBank]
}

struct RemoteBank: Codable {
    var FinancialInstitutionId: Int
    var Name: String
    var Alias: String
    var LogoUrl: String
    var Order: Int 
}
