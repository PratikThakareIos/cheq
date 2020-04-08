//
//  Double_Extention.swift
//  Cheq
//
//  Created by Manish.D on 08/04/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation

extension Double {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        return numberFormatter
    }()

    var strWithCommas: String {
        return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        return numberFormatter
    }()

    var strWithCommas: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}


//let number = 31908551587.0
//print(number.strWithCommas) // "31,90,85,51,587"
