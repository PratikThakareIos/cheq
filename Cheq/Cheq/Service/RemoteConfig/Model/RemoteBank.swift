//
//  RemoteBank.swift
//  Cheq
//
//  Created by Xuwei Liang on 22/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

struct RemoteBankList {
    var banks: [RemoteBank]
    
    func mapping()-> [String: RemoteBank] {
        var mapping = [String: RemoteBank]()
        for bank: RemoteBank in self.banks {
            mapping[bank.name] = bank
        }
        return mapping
    }
    
    func mappingByFinancialInstitutionId()->[String: RemoteBank] {
        var mapping = [String: RemoteBank]()
        for bank: RemoteBank in self.banks {
            mapping[String(bank.financialInstitutionId)] = bank
        }
        return mapping
    }
}

struct RemoteBank: Codable {
    var financialInstitutionId: Int
    var name: String
    var alias: String?
    var logoUrl: String
    var order: Int
    
    enum CodingKeys: String, CodingKey {
        case financialInstitutionId = "FinancialInstitutionId"
        case name = "Name"
        case alias = "Alias"
        case logoUrl = "LogoUrl"
        case order = "Order"
    }
    
    
}
